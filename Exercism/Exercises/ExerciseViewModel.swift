//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation
import ExercismSwift

class ExerciseViewModel: ObservableObject {
    @Published var exerciseDoc: ExerciseDocument? = nil
    @Published var exercise: ExerciseItem? = nil
    @Published var selectedFile: ExerciseFile? = nil
    @Published var selectedCode: String = ""
    @Published var showTestSubmissionResponseMessage = false
    @Published var testSubmissionResponseMessage = ""
    @Published var averageTestDuration: Double? = nil
    @Published var testRun: TestRun? = nil
    @Published var showSolutionSubmissionResponseMessage = false
    @Published var solutionSubmissionResponseMessage = ""
    @Published var submissionLink: String? = nil
    private var codes = [String: String]()

    var instruction: String? {
        guard let instructions = exerciseDoc?.instructions else {
            return nil
        }

        do {
            return try String(contentsOf: instructions, encoding: .utf8)
        } catch {
            return nil
        }
    }

    func getDocument(track: String, exercise: String) {
        downloadSolutions(track, exercise)
    }

    private func getLocalExercise(track: String, exercise: String) {
        let solutionFiles = exerciseDoc!.solutions.map { url in
            ExerciseFile.fromURL(url)
        }
        self.exercise = ExerciseItem(name: exercise, language: track, files: solutionFiles)
        selectFile(solutionFiles.first)
    }

    private func getOrCreateSolutionDir(track: String, exercise: String) -> URL? {
        let fileManager = FileManager.default
        do {
            let docsFolder = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)

            let solutionDir = docsFolder.appendingPathComponent("\(track)/\(exercise)/", isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.relativePath) {
                do {
                    try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
                } catch {
                    print("Error creating solution directory: \(error.localizedDescription)")
                    return nil
                }
            }

            return solutionDir
        } catch {
            print("URL error: \(error.localizedDescription)")
            return nil
        }
    }

    func downloadSolutions(_ track: String, _ exercise: String) {
        guard let client = getClient() else {
            return
        }
        client.downloadSolution(for: track, exercise: exercise) { result in
            switch result {
            case .success(let exerciseDoc):
                self.exerciseDoc = exerciseDoc
                self.getLocalExercise(track: track, exercise: exercise)
            case .failure(let error):
                print("This is the error: \(error)")
            }
        }
    }

    func selectFile(_ file: ExerciseFile?) {
        if let file = file {
            selectedFile = file
        }
        selectedCode = getSelectedCode() ?? ""
    }

    func getSelectedCode() -> String? {
        do {
            guard let selected = selectedFile else {
                return nil
            }
            guard let code = codes[selected.id] else {
                let code = try String(contentsOf: selected.url, encoding: .utf8)
                codes[selected.id] = code
                return code
            }
            print("found code: \(selected.id)")

            return code
        } catch {
            print("Error getting file content: \(error)")
            return nil
        }
    }

    func getTitle() -> String {
        guard let exercise = exercise else {
            return ""
        }
        return "\(exercise.language) / \(exercise.name)"
    }

    func updateCode(_ code: String) {
        if let selected = selectedFile {
            codes[selected.id] = code
        }
    }

    func updateFile() -> Bool {
        if !selectedCode.isEmpty && selectedFile != nil {
            do {
                try selectedCode.write(to: selectedFile!.url, atomically: false, encoding: .utf8)
                return true
            } catch {
                print("Error update \(selectedFile!.id) with \(selectedCode)")
                return false
            }
        }

        return false
    }

    func runTest() {
        // Update with latest code
        let _ = updateFile()
        guard let client = getClient() else {
            return
        }
        guard let solutionId = exerciseDoc?.solution.id else {
            return
        }
        if let exercise = exercise {
            var solutionsData = [SolutionFileData]()
            for file in exercise.files {
                if let code = try? String(contentsOf: file.url, encoding: .utf8) {
                    solutionsData.append(SolutionFileData(fileName: file.name, content: code))
                }
            }
            client.runTest(
                for: solutionId,
                withFileContents: solutionsData
            ) { [weak self] result in
                print(result)
                switch result {
                case .success(let submission):
                    switch submission.testsStatus {
                    case .passed:
                        self?.testSubmissionResponseMessage = "This solution correctly solves the latest version of this exercise."
                        self?.showTestSubmissionResponseMessage = true
                        break
                    case .queued:
                        self?.getTestRun(links: submission.links)
                        break
                    default:
                        self?.testSubmissionResponseMessage = "This solution does not fully solve the latest version of this exercise"
                        self?.showTestSubmissionResponseMessage = true
                    }
                case .failure(let error):
                    if case let .apiError(_, type, message) = error {
                        if (type == "duplicate_submission") {
                            self?.testSubmissionResponseMessage = message
                            self?.showTestSubmissionResponseMessage = true
                        }
                    }
                }
            }
        }
    }

    func getTestRun(links: SubmissionLinks) {
        guard let client = getClient() else {
            testSubmissionResponseMessage = "Test run failed. Try again."
            showTestSubmissionResponseMessage = true
            return
        }

        client.getTestRun(withLink: links.testRun) { [weak self] result in
            print(result)
            switch result {
            case .success(let testRunResponse):
                if let testRun = testRunResponse.testRun {
                    self?.averageTestDuration = nil
                    self?.processTestRun(testRun: testRun, links: links)
                } else {
                    self?.averageTestDuration = Double(testRunResponse.testRunner.averageTestDuration)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (self?.averageTestDuration! ?? 5.0)!) {
                        self?.getTestRun(links: links)
                    }
                }
            case .failure(_):
                self?.testSubmissionResponseMessage = "Test run failed. Try again."
                self?.showTestSubmissionResponseMessage = true
                self?.averageTestDuration = nil
            }
        }
    }

    var canSubmitSolution: Bool {
        submissionLink != nil
    }

    func submitSolution() {
        if (!canSubmitSolution) {
            solutionSubmissionResponseMessage = "You need to run the tests before submitting."
            showSolutionSubmissionResponseMessage = true
            return
        }

        guard let client = getClient() else {
            solutionSubmissionResponseMessage = "Error submitting solution. Try again."
            showSolutionSubmissionResponseMessage = true
            return
        }

        client.submitSolution(withLink: submissionLink!) { [weak self] result in
            print(result)
            switch result {
            case .success(let response):
                switch response.iteration.testsStatus {
                case .passed:
                    self?.solutionSubmissionResponseMessage = "This solution correctly solves the latest version of this exercise."
                    self?.showSolutionSubmissionResponseMessage = true
                    break
                default:
                    self?.solutionSubmissionResponseMessage = "This solution does not fully solve the latest version of this exercise"
                    self?.showSolutionSubmissionResponseMessage = true
                }
            case .failure(_):
                self?.solutionSubmissionResponseMessage = "Error submitting solution. Try again."
                self?.showSolutionSubmissionResponseMessage = true
            }
        }

    }

    private func processTestRun(testRun: TestRun, links: SubmissionLinks) {
        if (testRun.status == .pass) {
            submissionLink = links.submit
        }
        self.testRun = testRun
    }

    private func getClient() -> ExercismClient? {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else {
            return nil
        }

        return ExercismClient(apiToken: token)
    }
}

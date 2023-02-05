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
                        self?.getTestRun(link: submission.links.testRun)
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

    func getTestRun(link: String) {
        guard let client = getClient() else {
            testSubmissionResponseMessage = "Test run failed. Try again."
            showTestSubmissionResponseMessage = true
            return
        }

        client.getTestRun(withLink: link) { [weak self] result in
            print(result)
            switch result {
            case .success(let testRunResponse):
                if let testRun = testRunResponse.testRun {
                    self?.averageTestDuration = nil
                    self?.processTestRun(testRun: testRun)
                } else {
                    self?.averageTestDuration = Double(testRunResponse.testRunner.averageTestDuration)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (self?.averageTestDuration! ?? 5.0)!) {
                        self?.getTestRun(link: link)
                    }
                }
            case .failure(_):
                self?.testSubmissionResponseMessage = "Test run failed. Try again."
                self?.showTestSubmissionResponseMessage = true
                self?.averageTestDuration = nil
            }
        }
    }

    private func processTestRun(testRun: TestRun) {
        let hasTasks = testRun.version >= 3 && !testRun.tasks.isEmpty && testRun.tests.allSatisfy {
            $0.taskId != nil
        }

        switch testRun.status {

        case .fail:
            self.testRun = testRun
        case .pass:
            print("handle pass")
        case .error, .ops_error:
            print("error")
        case .timeout:
            print("handle timeout")
        default:
            print("do nothing")
        }

    }
//
//    private func processFailedTestRun(testRun: TestRun, hasTasks: Bool) {
//        numFailedTest = testRun.tests.filter { test in
//            test.status == TestStatus.fail || test.status == TestStatus.error
//        }
//        if (hasTasks) {
//            numFailedTasks = Set(
//                failed
//                    .filter {
//                        $0.taskId != nil
//                    }
//                    .map {
//                        $0.taskId
//                    }
//            )
//                .count
//
//            let allTest = testRun.tests
//            testGroupedByTaskList = testRun.tasks.map { task in
//                let test = allTest.filter {
//                    $0.taskId == task.id
//                }
//                return TestGroup(id: task.id, title: task.title, test: test)
//            }
//
////            num = "\(testRun.tasks.count - numFailedTasks) / \(testRun.tasks.count) "
//
//        }
//    }

    private func getClient() -> ExercismClient? {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else {
            return nil
        }

        return ExercismClient(apiToken: token)
    }
}

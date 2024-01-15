//
//  ViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 22/08/2023.
//

import Foundation
import ExercismSwift

enum ExerciseModelResponse: Equatable {
    case solutionPassed, wrongSolution, runFailed, errorSubmitting, errorRunningTest, idle
    case duplicateSubmission(message: String)
    case solutionPublished
    case solutionNotPublished

    var description: String {
        switch self {
        case .solutionPassed:
            return Strings.correctSolution.localized()
        case .wrongSolution:
            return Strings.wrongSolution.localized()
        case .runFailed:
            return Strings.runFailed.localized()
        case .errorSubmitting:
            return Strings.errorSubmitting.localized()
        case .errorRunningTest:
            return Strings.runTestsError.localized()
        case .idle:
            return ""
        case .duplicateSubmission(let message):
            return message
        case .solutionPublished:
            return Strings.solutionPublished.localized()
        case .solutionNotPublished:
            return Strings.solutionNotPublished.localized()
        }
    }
}


enum SelectedTab: Int, Tabbable {
    case Instruction = 0
    case Result

    var icon: String {
        switch self {
        case .Instruction:
            return "list.bullet"
        case .Result:
            return "checkmark.icloud.fill"
        }
    }

    var title: String {
        switch self {
        case .Instruction:
            return "Instruction"
        case .Result:
            return "Result"
        }
    }
}

extension ExerciseFile: Tabbable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(icon)
        hasher.combine(title)
    }

    var icon: String {
        self.iconName
    }

    var title: String {
        self.name
    }

}

// need to throw custom` errors
@MainActor
final class ExerciseViewModel: ObservableObject {
    @Published var selectedFile: ExerciseFile!
    @Published var instruction: String?
    @Published var selectedTab: SelectedTab = .Instruction
    @Published var exerciseDoc: ExerciseDocument? = nil
    @Published var averageTestDuration: Double? = nil
    @Published var submissionLink: String? = nil
    @Published var testRun: TestRun? = nil
    @Published var selectedCode: String = ""
    @Published var exerciseItem: ExerciseItem? = nil
    @Published var testSubmissionResponseMessage: Bool = false
    @Published var showTestSubmissionResponseMessage = false
    @Published var solutionToSubmit: Solution?
    @Published var title = ""
    @Published var operationStatus = ExerciseModelResponse.idle {
        didSet {
            showTestSubmissionResponseMessage = operationStatus != .idle
        }
    }
    private let fetcher = Fetcher()
    private var codes = [String: String]()
    static let shared = ExerciseViewModel()

    var language: String? {
        guard let language = exerciseDoc?.solution.exercise.trackLanguage else {
            return nil
        }
        return language
    }

    func getDocument(_ track: String, _ exercise: String) async throws -> [ExerciseFile] {
        exerciseDoc = try await downloadSolutions(track, exercise)
        if let instructionURL = exerciseDoc!.instructions {
            instruction = try getInstruction(instructionURL)
        }
        let exercises = getLocalExercise(track, exercise, exerciseDoc!)
        selectedFile = exercises.first
        selectFile(selectedFile)
        return exercises
    }
    
    @Published var currentSolutionIterations: [Iteration] = []
    
    var sortedIterations: [Iteration] {
        currentSolutionIterations.sorted { $0.idx > $1.idx }
    }
    
    func getIterations(for solution: Solution) async {
        do {
            currentSolutionIterations = try await TrackModel.shared.getIterations(for: solution.uuid)
        } catch {
            print("Error getting iterations:", error)
        }
    }
    
    // Pre-select the most recent iteration
    func getDefaultIterationIdx() -> Int {
        currentSolutionIterations.last?.idx ?? 1
    }

    private func getLocalExercise(_ track: String, _ exercise: String, _ exerciseDoc: ExerciseDocument) -> [ExerciseFile] {
        let solutionFiles =  exerciseDoc.solutions.map { ExerciseFile.fromURL($0) }
        self.exerciseItem = ExerciseItem(name: exercise, language: track, files: solutionFiles)
        self.title = "\(track)/ \(exercise)"
        return solutionFiles
    }

    private func getInstruction(_ instructions: URL) throws -> String {
        return try String(contentsOf: instructions, encoding: .utf8)
    }

    private func downloadSolutions(_ track: String, _ exercise: String) async throws -> ExerciseDocument {
        return try await fetcher.downloadSolutions(track, exercise)
    }

    private func selectFile(_ file: ExerciseFile) {
        selectedCode = getSelectedCode() ?? ""
    }

    func submitSolution() {
        if (!canSubmitSolution) {
            operationStatus = .errorRunningTest
        }
       Task { await performSubmit() }
    }

    private func performSubmit() async {
        do {
            let result = try await fetcher.submitSolution(submissionLink!)
            switch result.iteration.testsStatus {
            case .passed:
                operationStatus = .solutionPassed
                break
            default:
                operationStatus = .wrongSolution
            }
        } catch {
            operationStatus = .runFailed
        }
    }
    
    func setSolutionToSubmit(_ solution: Solution?) {
        solutionToSubmit = solution
    }
    
    func completeExercise(solutionId: String, publish: Bool, iterationIdx: Int?) async  {
        do {
            let result = try await fetcher.completeSolution(solutionId,
                                                            publish: publish,
                                                            iterationIdx: iterationIdx)
            
            print("Completed Solution:", result)
            solutionToSubmit = nil
            operationStatus = .solutionPublished
        } catch {
            operationStatus = .runFailed
            print("Unable to complete exercise:", error)
        }
    }

    private func getTestRun(_ submissionLink: SubmissionLinks) async throws {
        let result =  try await fetcher.getTestRun(submissionLink.testRun)

        if let testRun = result.testRun {
            averageTestDuration = nil
            processTestRun(testRun: testRun, links: submissionLink)
        } else {
            self.averageTestDuration = Double(result.testRunner.averageTestDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + (self.averageTestDuration ?? 5.0 )) {
                Task {
                    try await self.getTestRun(submissionLink)
                }
            }
        }
    }

    func runTest() {
        selectedTab = .Result
        updateFile()

        guard let exerciseSolutionId = exerciseDoc?.solution.id else {
            operationStatus = .errorRunningTest
            return
        }
        Task {
            do {
                let solutionData = try getSolutionFileData()
                let runResult = try await self.performRunTest(exerciseSolutionId, solutionData)

                switch runResult.testsStatus {
                case .queued:
                    try await getTestRun(runResult.links)
                case .passed:
                    operationStatus = .solutionPassed
                default:
                    operationStatus = .wrongSolution
                }
            } catch let error {
                if let clientError = error as? ExercismClientError {
                    if case let .apiError(_, type, message) = clientError, type == "duplicate_submission" {
                        operationStatus = .duplicateSubmission(message: message)
                    } else {
                        operationStatus = .errorRunningTest
                    }
                } else {
                    operationStatus = .errorRunningTest
                }
            }
        }
    }

    private func performRunTest(_ solutionId: String, _ contents: [SolutionFileData]) async throws -> TestSubmission {
        return try await fetcher.runTest(solutionId, contents: contents)
    }

    private func getSolutionFileData() throws -> [SolutionFileData] {
        var solutionsData = [SolutionFileData]()
        if let exercise = exerciseItem {
            solutionsData = try exercise.files.map { exerciseFile in
                let code = try String(contentsOf: exerciseFile.url, encoding: .utf8)
                return SolutionFileData(fileName: exerciseFile.name, content: code)
            }
        }
        return solutionsData
    }

    var canSubmitSolution: Bool {
        submissionLink != nil
    }

    func getSelectedCode() -> String? {
        do {
            guard let code = codes[selectedFile.id] else {
                let code = try String(contentsOf: selectedFile.url, encoding: .utf8)
                codes[selectedFile.id] = code
                return nil
            }
            return code
        } catch {
            return nil
        }
    }


    private func processTestRun(testRun: TestRun, links: SubmissionLinks) {
        if (testRun.status == .pass) {
            submissionLink = links.submit
        }
        self.testRun = testRun
    }

    // can we make this throwing??
    @discardableResult
    func updateFile() -> Bool {
        if !selectedCode.isEmpty {
            do {
                try selectedCode.write(to: selectedFile.url, atomically: false, encoding: .utf8)
                return true
            } catch {
                print("Error update \(selectedFile.id) with \(selectedCode)")
                return false
            }
        }

        return false
    }

    func updateCode(_ code: String) {
        codes[selectedFile.id] = code
    }
}

//
//  ExerciseViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 22/08/2023.
//

import Foundation
import ExercismSwift

enum SelectedTab: Int, Tabbable {
    case instruction = 0
    case result
    case tests

    var icon: String {
        switch self {
        case .instruction:
            return "list.bullet"
        case .result:
            return "checkmark.icloud.fill"
        case .tests:
            return "checklist.unchecked"
        }
    }

    var title: String {
        switch self {
        case .instruction:
            return "Instruction"
        case .result:
            return "Result"
        case .tests:
            return "Tests"
        }
    }
}

enum ExerciseModelResponse: Equatable {
    case solutionPassed, wrongSolution, runFailed, errorSubmitting, errorRunningTest, idle
    case duplicateSubmission(message: String)
    case solutionPublished
    case solutionNotPublished
    case genericError(error: String)

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
        case .genericError(let error):
            return error
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
    @Published var selectedTab: SelectedTab = .instruction
    @Published var averageTestDuration: Double?
    @Published var submissionLink: String?
    @Published var testRun: TestRun?
    @Published var selectedCode: String = "" {
        didSet {
            updateCode(selectedCode)
        }
    }
    @Published var testSubmissionResponseMessage: Bool = false
    @Published var showTestSubmissionResponseMessage = false
    @Published var solutionToSubmit: Solution?
    @Published var title = ""
    @Published var operationStatus = ExerciseModelResponse.idle {
        didSet {
            showTestSubmissionResponseMessage = operationStatus != .idle
        }
    }
    @Published var currentSolutionIterations: [Iteration] = []
    @Published var language: String?
    @Published var state: LoadingState<[ExerciseFile]> = .idle
    @Published var tests: String?
    @Published var canRunTests: Bool = true
    @Published var canMarkAsComplete: Bool = false

    private let fetcher = Fetcher()
    private var codes = [String: String]()
    private var solution: Solution?
    private let nanosecondsPerSecond: Double = 1_000_000_000
    private var exerciseItem: ExerciseItem?
    var canSubmitSolution: Bool {
        submissionLink != nil
    }
    @AppSettings(\.testSubmission) private var testSubmission

    // MARK: - on Appear Operations

    var sortedIterations: [Iteration] {
        currentSolutionIterations.sorted { $0.idx > $1.idx }
    }

    init(_ track: String, _ exercise: String, _ solution: Solution? = nil) {
        self.solution = solution
        canMarkAsComplete = solution?.status == .iterated || solution?.status == .published
        Task {
            await getDocument(track, exercise)
        }
    }

    private func getDocument(_ track: String, _ exercise: String) async {
        state = .loading
        do {
            let exercises = try await withThrowingTaskGroup(of: Optional<ExerciseFile>.self) { _ in
                let exerciseDoc = try await downloadSolutions(track, exercise)
                getLanguage(exerciseDoc)
                instruction = try getExerciseInstructions(exerciseDoc)
                tests = try getExerciseTests(exerciseDoc)
                try await runUsingSavedLink()
                let exercises = getLocalExercise(track, exercise, exerciseDoc)
                selectedFile = exercises.first
                selectedCode = getSelectedCode() ?? ""
                await getIterations(for: solution)
                return exercises
            }

            state = .success(exercises)
        } catch {
            operationStatus = .genericError(error: error.localizedDescription)
            state = .failure(error as? ExercismClientError ?? ExercismClientError.unsupportedResponseError)
        }
    }

    private func getLanguage(_ exerciseDoc: ExerciseDocument?) {
        language = exerciseDoc?.solution.exercise.trackLanguage
    }

    private func getExerciseTests(_ exerciseDoc: ExerciseDocument) throws -> String? {
        guard let testsURL = exerciseDoc.tests.first else { return nil }
        return try String(contentsOf: testsURL, encoding: .utf8)
    }

    private func getExerciseInstructions(_ exerciseDoc: ExerciseDocument) throws -> String? {
        guard let instructionURL = exerciseDoc.instructions else { return nil }
        return try String(contentsOf: instructionURL, encoding: .utf8)
    }

    private func runUsingSavedLink() async throws {
        if let solutionId = solution?.id, let savedSubmission = testSubmission[solutionId] {
            switch savedSubmission.testsStatus {
            case .queued:
                try await getTestRun(savedSubmission.links)
            case .passed:
                operationStatus = .solutionPassed
            default:
                operationStatus = .wrongSolution
            }
        }
    }

    private func getSelectedCode() -> String? {
        do {
            guard let code = codes[selectedFile.id] else {
                let code = try String(contentsOf: selectedFile.url, encoding: .utf8)
                codes[selectedFile.id] = code
                return code
            }
            return code
        } catch {
            return nil
        }
    }

    private func downloadSolutions(_ track: String, _ exercise: String) async throws -> ExerciseDocument {
        return try await fetcher.downloadSolutions(track, exercise)
    }

    private func getLocalExercise(_ track: String,
                                  _ exercise: String,
                                  _ exerciseDoc: ExerciseDocument) -> [ExerciseFile] {
        let solutionFiles = exerciseDoc.solutions.map { ExerciseFile(from: $0) }
        self.exerciseItem = ExerciseItem(name: exercise, language: track, files: solutionFiles)
        self.title = "\(track)/ \(exercise)"
        return solutionFiles
    }

    // MARK: - Iterations

    func getIterations(for solution: Solution?) async {
        do {
            guard let solution else { return }
            currentSolutionIterations = try await fetcher.getIterations(solution.uuid)
        } catch {
            if case let ExercismClientError.apiError(_, _, message) = error {
                operationStatus = .genericError(error: message)
            } else {
                operationStatus = .genericError(error: error.localizedDescription)
            }
        }
    }

    // Pre-select the most recent iteration
    func getDefaultIterationIdx() -> Int {
        currentSolutionIterations.last?.idx ?? 1
    }

    // MARK: - Submit Solution

    func submitSolution() {
        if !canSubmitSolution {
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
                setSolutionToSubmit()
            default:
                operationStatus = .wrongSolution
            }
        } catch {
            operationStatus = .runFailed
        }
    }

    func setSolutionToSubmit() {
        if canMarkAsComplete {
            solutionToSubmit = solution
        }
    }

    // MARK: - Complete Exercise

    func completeExercise(solutionId: String, publish: Bool, iterationIdx: Int?) async throws -> CompletedSolution {
        do {
            let result = try await fetcher.completeSolution(solutionId,
                                                            publish: publish,
                                                            iterationIdx: iterationIdx)
            solutionToSubmit = nil
            operationStatus = .solutionPublished
            return result
        } catch {
            operationStatus = .solutionNotPublished
            throw error
        }
    }

    // MARK: - Tests

    func runTest() {
        canRunTests = false
        selectedTab = .result
        updateFile()

        guard let exerciseSolutionId = solution?.id else {
            operationStatus = .errorRunningTest
            return
        }
        Task {
            do {
                let solutionData = try getSolutionFileData()
                let runResult = try await self.performRunTest(exerciseSolutionId, solutionData)
                switch runResult.testsStatus {
                case .queued:
                    testSubmission[exerciseSolutionId] = runResult
                    try await getTestRun(runResult.links)
                case .passed:
                    operationStatus = .solutionPassed
                default:
                    operationStatus = .wrongSolution
                }
            } catch let error {
                canRunTests = true
                operationStatus = .errorRunningTest
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

    private func getTestRun(_ submissionLink: SubmissionLinks) async throws {
        let result = try await fetcher.getTestRun(submissionLink.testRun)

        if let testRun = result.testRun {
            averageTestDuration = nil
            processTestRun(testRun: testRun, links: submissionLink)
        } else {
            self.averageTestDuration = Double(result.testRunner.averageTestDuration)
            try await Task.sleep(nanoseconds: UInt64((self.averageTestDuration ?? 5.0) * nanosecondsPerSecond))
            try await self.getTestRun(submissionLink)
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

    private func processTestRun(testRun: TestRun, links: SubmissionLinks) {
        canRunTests = true
        if testRun.status == .pass {
            submissionLink = links.submit
        }
        self.testRun = testRun
    }

    func updateFile() {
        guard !selectedCode.isEmpty else { return }
        do {
            try selectedCode.write(to: selectedFile.url, atomically: false, encoding: .utf8)
        } catch {
            let message = "Error updating \(selectedFile.id) with \(selectedCode)"
            operationStatus = .genericError(error: message)
        }
    }

    private func updateCode(_ code: String) {
        codes[selectedFile.id] = code
    }
}

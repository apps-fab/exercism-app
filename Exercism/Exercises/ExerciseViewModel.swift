//
//  ExerciseViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 22/08/2023.
//

import Foundation
import ExercismSwift

@MainActor
final class ExerciseViewModel: ObservableObject {
    @AppSettings(\.testSubmission) private var testSubmission
    @Published var selectedFile: ExerciseFile!
    @Published var instruction: String?
    @Published var showTestSubmissionResponseMessage = false
    @Published var title = ""
    @Published var currentSolutionIterations = [Iteration]()
    @Published var language: String?
    @Published var state: LoadingState<[ExerciseFile]> = .idle
    @Published var tests: String?
    @Published var submissionLink: String?
    @Published var solutionToSubmit: Solution?
    @Published var testRun: TestRun?
    @Published var averageTestDuration: Double?
    @Published var selectedTab: SelectedTab = .instruction
    @Published var canSubmit = false
    @Published var canRunTests = true
    @Published var showPublishModal = false
    @Published var showErrorAlert = false
    @Published var canMarkAsComplete: Bool = false
    @Published var runStatus = ExerciseModelResponse.idle {
        didSet {
            showTestSubmissionResponseMessage = runStatus != .idle
        }
    }
    @Published var solution: Solution?
    @Published var selectedCode: String = "" {
        didSet {
            updateCode(selectedCode)
        }
    }
    private let nanosecondsPerSecond: Double = 1_000_000_000
    private let fetcher = Fetcher()
    private var codes = [String: String]()
    private var exerciseItem: ExerciseItem?

    // MARK: - on Appear Operations

    var sortedIterations: [Iteration] {
        currentSolutionIterations.sorted { $0.idx > $1.idx }
    }

    init(_ track: String, _ exercise: String, _ solution: Solution? = nil) {
        self.solution = solution
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
                let exercises = getLocalExercise(track, exercise, exerciseDoc)
                selectedFile = exercises.first
                selectedCode = getSelectedCode() ?? ""
                await getIterations(for: solution)
                return exercises
            }

            state = .success(exercises)
        } catch let appError as  ExercismClientError {
            state = .failure(appError)
        } catch {
            state = .failure(ExercismClientError.genericError(error))
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

    func revertToStart() {
        guard let solution else { return }
        Task {
            do {
                let solution = try await fetcher.revertToStart(solution.uuid)
                selectedCode = solution.files.first?.content ?? ""
            } catch let appError as ExercismClientError {
                canRunTests = true
                runStatus = .genericError(error: appError.description)
            } catch {
                canRunTests = true
                runStatus = .genericError(error: error.localizedDescription)
            }
        }
    }

    private func downloadSolutions(_ track: String, _ exercise: String) async throws -> ExerciseDocument {
        return try await fetcher.downloadSolutions(track, exercise)
    }

    private func getLocalExercise(_ track: String,
                                  _ exercise: String,
                                  _ exerciseDoc: ExerciseDocument) -> [ExerciseFile] {
        let solutionFiles = exerciseDoc.solutions.map { ExerciseFile(from: $0) }
        exerciseItem = ExerciseItem(name: exercise, language: track, files: solutionFiles)
        self.title = "\(track)/ \(exercise)"
        return solutionFiles
    }

    // MARK: - Iterations

    func getIterations(for solution: Solution?) async {
        do {
            guard let solution else { return }
            currentSolutionIterations = try await fetcher.getIterations(solution.uuid)
        } catch let appError as ExercismClientError {
            canRunTests = true
            runStatus = .genericError(error: appError.description)
        } catch {
            canRunTests = true
            runStatus = .genericError(error: error.localizedDescription)
        }
    }

    func runTests() async {
        canRunTests = false
        selectedTab = .result
        updateFile()
        guard let solutionId = solution?.id else {
            runStatus = .runFailed
            return
        }

        do {
            let solutionData = try getSolutionFileData()
            let runResult = try await fetcher.runTest(solutionId, contents: solutionData)
            switch runResult.testStatus {
            case .queued:
                saveTestRun(runResult, solutionId)
                try await getTestRun(for: runResult.links)
            case .passed:
                runStatus = .solutionPassed
            default:
                runStatus = .runFailed
            }
        } catch let appError as ExercismClientError {
            canRunTests = true
            runStatus = .genericError(error: appError.description)
        } catch {
            canRunTests = true
            runStatus = .genericError(error: error.localizedDescription)
        }
    }

    private func getTestRun(for submissionLink: SubmissionLinks) async throws {
        let result = try await fetcher.getTestRun(submissionLink.testRun)

        if let testRun = result.testRun {
            canRunTests = true
            averageTestDuration = nil
            processTestRun(testRun: testRun, links: submissionLink)
        } else {
            averageTestDuration = Double(result.testRunner.averageTestDuration)
            try await Task.sleep(nanoseconds: UInt64((self.averageTestDuration ?? 5.0) * nanosecondsPerSecond))
            try await self.getTestRun(for: submissionLink)
        }
    }

    func runUsingSavedLink() {
        Task {
            if let solutionId = solution?.id, let savedSubmission = testSubmission[solutionId] {
                switch savedSubmission.testStatus {
                case .queued:
                    try await getTestRun(for: savedSubmission.links)
                case .passed:
                    runStatus = .solutionPassed
                default:
                    runStatus = .wrongSolution
                }
            }
        }
    }

    private func saveTestRun(_ runResult: TestSubmission, _ solutionId: String) {
        testSubmission[solutionId] = runResult
    }

    private func handleRunStatus() {
        switch runStatus {
        case .idle:
            return
        case .solutionPublished, .genericError, .runFailed, .wrongSolution, .solutionPassed:
            showErrorAlert = true
        }
    }

    private func processTestRun(testRun: TestRun, links: SubmissionLinks) {
        if testRun.status == .pass {
            submissionLink = links.submit
        }
        self.testRun = testRun
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

    func submitSolution() async {
        canSubmit = false
        guard let submissionLink = submissionLink else {
            return
        }

        do {
            let result = try await fetcher.submitSolution(submissionLink)
            switch result.iteration.testsStatus {
            case .passed:
                runStatus = .solutionPassed
                solutionToSubmit = solution
                selectedTab = .instruction
                canMarkAsComplete = true
            default:
                runStatus = .wrongSolution
            }
        } catch let appError as ExercismClientError {
            runStatus = .genericError(error: appError.description)
        } catch {
            runStatus = .genericError(error: error.localizedDescription)
        }
    }

    func completeExercise(_ publish: Bool, _ selectedIteration: Int?) async -> Bool {
        guard let solutionId = solution?.id else { return false }
        do {
            _ = try await fetcher.completeSolution(solutionId,
                                                   publish: publish,
                                                   iterationIdx: selectedIteration)
            runStatus = .solutionPublished
            return true
        } catch let appError as ExercismClientError {
            runStatus = .genericError(error: appError.description)
        } catch {
            runStatus = .genericError(error: error.localizedDescription)
        }
        return false
    }

    // Pre-select the most recent iteration
    func getDefaultIterationIdx() -> Int {
        currentSolutionIterations.last?.idx ?? 1
    }

    func updateFile() {
        guard !selectedCode.isEmpty else { return }
        do {
            try selectedCode.write(to: selectedFile.url, atomically: false, encoding: .utf8)
        } catch {
            let message = "Error updating \(selectedFile.id) with \(selectedCode)"
            runStatus = .genericError(error: message)
        }
    }

    private func updateCode(_ code: String) {
        codes[selectedFile.id] = code
    }
}

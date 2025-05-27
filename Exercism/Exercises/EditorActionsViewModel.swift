//
//  EditorActionsViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 16/05/2025.
//

import Foundation
import ExercismSwift

@MainActor
class EditorActionsViewModel: ObservableObject {
    @AppSettings(\.testSubmission) private var savedTestSubmission
    @Published var currentSolutionIterations = [Iteration]()
    @Published var canRunTests = true
    @Published var canSubmitSolution = false
    @Published var solutionUUID: String
    @Published var exerciseItem: ExerciseItem?
    @Published var testRun: TestRun?
    @Published var selectedTab: SelectedTab = .instruction
    @Published var showErrorAlert = false
    @Published var errorMessage: String = ""
    @Published var state: EditorActionState = .idle {
        didSet {
            handleActionState()
        }
    }
    private let nanosecondsPerSecond: Double = 1_000_000_000
    private let fetcher: FetchingProtocol
    var sortedIterations = [Iteration]()

    init(fetcher: FetchingProtocol? = nil, solutionUUID: String, exerciseItem: ExerciseItem?, iterations: [Iteration]) {
        self.fetcher = fetcher ?? Fetcher()
        self.solutionUUID = solutionUUID
        self.exerciseItem = exerciseItem
        sortedIterations = currentSolutionIterations.sorted { $0.idx > $1.idx }
        Task { try? await runSavedTest() }
    }

    private func handleActionState() {
        switch state {
        case .testRunSuccess(_, let testRun):
            self.testRun = testRun
            canSubmitSolution = true
            canRunTests = true

        case .actionErrored(let message):
            errorMessage = message
            showErrorAlert = true

        case .submitSuccess:
            selectedTab = .instruction
            canSubmitSolution = true

        case .submitWrongSolution, .solutionPublished, .submitError:
            errorMessage = state.description
            showErrorAlert = true

        case .testInProgress:
            canRunTests = false

        case .submitInProgress:
            canSubmitSolution = false

        case .idle, .getTestRunSuccess:
            canRunTests = true
        }
    }

    func runTests() async {
        selectedTab = .result
        await executeRunTest()
    }

    private func executeRunTest() async {
        do {
            let solutionsData = try getSolutionFileData()
            let runResult = try await fetcher.runTest(solutionUUID, contents: solutionsData)
            switch runResult.testStatus {
            case .queued:
                saveTestRun(runResult, solutionUUID)
                try await getTestRun(for: runResult.links)
            default:
                return
            }
        } catch let appError as ExercismClientError {
            state = .actionErrored(appError.description)
        } catch {
            state = .actionErrored(error.localizedDescription)
        }
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

    private func runSavedTest() async throws {
        if let savedSubmission = savedTestSubmission[solutionUUID] {
            switch savedSubmission.testStatus {
            case .queued:
                try await getTestRun(for: savedSubmission.links)
            default:
                return
            }
        } else {
            await executeRunTest()
        }
    }

    private func saveTestRun(_ runResult: TestSubmission, _ solutionId: String) {
        savedTestSubmission[solutionId] = runResult
    }

    private func getTestRun(for submissionLink: SubmissionLinks) async throws {
        let result = try await fetcher.getTestRun(submissionLink.testRun)

        if let testRun = result.testRun {
            state = .testRunSuccess(submissionLink, testRun)
        } else {
            let averageTestDuration = Double(result.testRunner.averageTestDuration)
            state = .testInProgress(averageTestDuration)
            try await Task.sleep(nanoseconds: UInt64((averageTestDuration) * nanosecondsPerSecond))
            try await self.getTestRun(for: submissionLink)
        }
    }

    func submitSolution() async {
        selectedTab = .result
        guard case let .testRunSuccess(link, test) = state, test.status == .pass else {
            state = .submitError
            return
        }

        do {
            let result = try await fetcher.submitSolution(link.submit)
            switch result.iteration.testsStatus {
            case .passed:
                state = .submitSuccess(solutionUUID)
            default:
                state = .submitWrongSolution
            }
        } catch let appError as ExercismClientError {
            state = .actionErrored(appError.description)
        } catch {
            state = .actionErrored(error.localizedDescription)
        }
    }

    func completeExercise(_ publish: Bool, _ selectedIteration: Int?) async -> Bool {
        guard case let .submitSuccess(submissionUUID) = state else {
            return false
        }

        do {
            _ = try await fetcher.completeSolution(submissionUUID, publish: publish, iterationIdx: selectedIteration)
            state = .solutionPublished
            return true
        } catch let appError as ExercismClientError {
            state = .actionErrored(appError.description)
            return  false
        } catch {
            state = .actionErrored(error.localizedDescription)
            return  false
        }
    }

    func revertToStart() async -> String {
        do {
            let solution = try await fetcher.revertToStart(solutionUUID)
            return solution.files.first?.content ?? ""
        } catch let appError as ExercismClientError {
            state = .actionErrored(appError.description)
        } catch {
            canRunTests = true
            state = .actionErrored(error.localizedDescription)
        }
        return ""
    }
}

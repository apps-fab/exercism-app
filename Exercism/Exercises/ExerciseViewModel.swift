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
    @Published var selectedFile: ExerciseFile!
    @Published var instruction: String?
    @Published var showTestSubmissionResponseMessage = false
    @Published var title = ""
    @Published var language: String?
    @Published var state: LoadingState<([ExerciseFile], EditorActionsViewModel)> = .idle
    @Published var tests: String?
    @Published var selectedTab: SelectedTab = .instruction
    @Published var canRunTests = true
    @Published var solutionUUID: String!
    @Published var selectedCode: String = ""
    @Published var actionsVM: EditorActionsViewModel?
    private let fetcher: FetchingProtocol
    private let track: String
    private let exercise: String

    // MARK: - on Appear Operations

    init(_ track: String, _ exercise: String, _ fetcher: FetchingProtocol? = nil) {
        self.fetcher = fetcher ?? Fetcher()
        self.exercise = exercise
        self.track = track
        Task {
            await getDocument()
        }
    }

    private func getDocument() async {
        state = .loading
        do {
            let exerciseDoc = try await downloadExerciseDoc()
            solutionUUID = exerciseDoc.solution.id
            let iterations = try await getIterations(for: solutionUUID)
            getLanguage(exerciseDoc)
            try getExerciseInstructions(exerciseDoc)
            try getExerciseTests(exerciseDoc)
            let exerciseFiles = createExerciseFile(from: exerciseDoc)
            let exerciseItem = createExerciseItem(from: exerciseFiles)
            let actionsViewModel = EditorActionsViewModel(fetcher: fetcher,
                                                          solutionUUID: solutionUUID,
                                                          exerciseItem: exerciseItem,
                                                          iterations: iterations)
            actionsVM = actionsViewModel
            selectedFile = exerciseFiles.first
            title = selectedFile.title
            selectedCode = getSelectedCode(for: selectedFile) ?? ""
            state = .success((exerciseFiles, actionsViewModel))
        } catch let appError as  ExercismClientError {
            state = .failure(appError)
        } catch {
            state = .failure(ExercismClientError.genericError(error))
        }
    }

    private func getLanguage(_ exerciseDoc: ExerciseDocument?) {
        language = exerciseDoc?.solution.exercise.trackLanguage
    }

    private func getExerciseTests(_ exerciseDoc: ExerciseDocument) throws {
        guard let testsURL = exerciseDoc.tests.first else { return }
        let tests = try String(contentsOf: testsURL, encoding: .utf8)
        self.tests = tests
    }

    private func getExerciseInstructions(_ exerciseDoc: ExerciseDocument) throws {
        guard let instructionURL = exerciseDoc.instructions else { return  }
        let instruction = try String(contentsOf: instructionURL, encoding: .utf8)
        self.instruction = instruction
    }

    private func getSelectedCode(for selectedFile: ExerciseFile) -> String? {
        try? String(contentsOf: selectedFile.url, encoding: .utf8)
    }

    private func downloadExerciseDoc() async throws -> ExerciseDocument {
        return try await fetcher.downloadSolutions(track, exercise)
    }

    private func createExerciseFile(from exerciseDoc: ExerciseDocument) -> [ExerciseFile] {
        let exerciseFiles = exerciseDoc.solutions.map {
            return ExerciseFile(from: $0)
        }
        return exerciseFiles
    }

    private func createExerciseItem(from exerciseFiles: [ExerciseFile]) -> ExerciseItem {
        return ExerciseItem(name: exercise, language: track, files: exerciseFiles)
    }

    // MARK: - Iterations

    func getIterations(for solution: String) async throws -> [Iteration] {
        return try await fetcher.getIterations(solution)
    }

    func revertToStart() async {
        selectedCode = await actionsVM?.revertToStart() ?? ""
    }

    func runTests() async {
        selectedTab = SelectedTab.result
        await actionsVM?.runTests()
    }

    func submitSolution() async {
        await actionsVM?.submitSolution()
    }

    func updateFile() -> Bool {
        guard !selectedCode.isEmpty else { return false }
        do {
            try selectedCode.write(to: selectedFile.url, atomically: false, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
}

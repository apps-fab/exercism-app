//
//  MockExercismClient.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import Foundation
import ExercismSwift

final class MockExercismClient: ExercismClientType {
    var onTracks: (() async throws(ExercismClientError) -> ListResponse<Track>)?
    var onExercises: ((String) async throws(ExercismClientError) -> ListResponse<Exercise>)?
    var onValidateToken: (() async throws(ExercismClientError) -> ValidateTokenResponse)?
    var onSolutions: ((String?, SolutionStatus?, MentoringStatus?)
                      async throws(ExercismClientError) -> ListResponse<Solution>)?
    var onDownloadSolution: ((String, String, String) async throws(ExercismClientError) -> ExerciseDocument)?
    var onInitialSolution: ((String) async throws(ExercismClientError) -> InitialFiles)?
    var onGetIterations: ((String) async throws(ExercismClientError) -> IterationResponse)?
    var onGetBadges: (() async throws(ExercismClientError) -> ListResponse<Badge>)?
    var onGetTestRun: ((String) async throws(ExercismClientError) -> TestRunResponse)?
    var onSubmitSolution: ((String) async throws(ExercismClientError) -> SubmitSolutionResponse)?
    var onCompleteSolution: ((String, Bool, Int?) async throws(ExercismClientError) -> CompletedSolution)?
    var onRunTest: ((String, [SolutionFileData]) async throws(ExercismClientError) -> TestSubmission)?

    func tracks() async throws(ExercismClientError) -> ListResponse<Track> {
        guard let onTracks = onTracks else {
            throw ExercismClientError.builderError(message: "onTracks not implemented")
        }
        return try await onTracks()
    }

    func exercises(for track: String) async throws(ExercismClientError) -> ListResponse<Exercise> {
        guard let onExercises = onExercises else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onExercises closure not set")
        }
        return try await onExercises(track)
    }

    func validateToken() async throws(ExercismClientError) -> ValidateTokenResponse {
        guard let onValidateToken = onValidateToken else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onValidateToken closure not set")
        }
        return try await onValidateToken()
    }

    func solutions(for track: String?,
                   withStatus status: SolutionStatus?,
                   mentoringStatus: MentoringStatus?) async throws(ExercismClientError) -> ListResponse<Solution> {
        guard let onSolutions = onSolutions else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onSolutions closure not set")
        }
        return try await onSolutions(track, status, mentoringStatus)
    }

    func downloadSolution(with id: String,
                          for track: String,
                          exercise: String) async throws(ExercismClientError) -> ExerciseDocument {
        guard let onDownloadSolution = onDownloadSolution else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onDownloadSolution closure not set")
        }
        return try await onDownloadSolution(id, track, exercise)
    }

    func initialSolution(for track: String) async throws(ExercismClientError) -> InitialFiles {
        guard let onInitialSolution = onInitialSolution else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onInitialSolution closure not set")
        }
        return try await onInitialSolution(track)
    }

    func getIterations(for solutionId: String) async throws(ExercismClientError) -> IterationResponse {
        guard let onGetIterations = onGetIterations else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onGetIterations closure not set")
        }
        return try await onGetIterations(solutionId)
    }

    func badges() async throws(ExercismClientError) -> ListResponse<Badge> {
        guard let onGetBadges = onGetBadges else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onGetBadges closure not set")
        }
        return try await onGetBadges()
    }

    func getTestRun(withLink link: String) async throws(ExercismClientError) -> TestRunResponse {
        guard let onGetTestRun = onGetTestRun else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onGetTestRun closure not set")
        }
        return try await onGetTestRun(link)
    }

    func submitSolution(withLink link: String) async throws(ExercismClientError) -> SubmitSolutionResponse {
        guard let onSubmitSolution = onSubmitSolution else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onSubmitSolution closure not set")
        }
        return try await onSubmitSolution(link)
    }

    func completeSolution(for solution: String,
                          publish: Bool,
                          iteration: Int?) async throws(ExercismClientError) -> CompletedSolution {
        guard let onCompleteSolution = onCompleteSolution else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onCompleteSolution closure not set")
        }
        return try await onCompleteSolution(solution, publish, iteration)
    }

    func runTest(for solution: String,
                 with contents: [SolutionFileData]) async throws(ExercismClientError) -> TestSubmission {
        guard let onRunTest = onRunTest else {
            throw ExercismClientError.builderError(message: "MockExercismClient.onRunTest closure not set")
        }
        return try await onRunTest(solution, contents)
    }
}

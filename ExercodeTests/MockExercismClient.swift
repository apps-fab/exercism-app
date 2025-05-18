//
//  MockExercismClient.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import Foundation
import ExercismSwift

final class MockExercismClient: ExercismClientType {
    var onTracks: ((@escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void) -> Void)?
    var onExercises: ((String, @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void) -> Void)?
    var onValidateToken: ((@escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void) -> Void)?
    var onSolutions: ((@escaping (Result<ListResponse<Solution>, ExercismClientError>) -> Void) -> Void)?
    var onDownloadSolution: ((String, String,
                              @escaping (Result<ExerciseDocument, ExercismClientError>) -> Void) -> Void)?
    var onInitialSolution: ((String, @escaping (Result<InitialFiles, ExercismClientError>) -> Void) -> Void)?
    var onGetIterations: ((String, @escaping (Result<IterationResponse, ExercismClientError>) -> Void) -> Void)?
    var onGetBadges: ((@escaping (Result<ListResponse<Badge>, ExercismClientError>) -> Void) -> Void)?
    var onGetTestRun: ((String, @escaping (Result<TestRunResponse, ExercismClientError>) -> Void) -> Void)?
    var onSubmitSolution: ((String, @escaping (Result<SubmitSolutionResponse, ExercismClientError>) -> Void) -> Void)?
    var onCompleteSolution: ((String, @escaping (Result<CompletedSolution, ExercismClientError>) -> Void) -> Void)?
    var onRunTest: ((String, [SolutionFileData],
                     @escaping (Result<TestSubmission, ExercismClientError>) -> Void) -> Void)?

    func tracks(completed: @escaping (Result<ListResponse<Track>, ExercismClientError>) -> Void) {
        onTracks?(completed)
    }

    func exercises(for track: String,
                   completed: @escaping (Result<ListResponse<Exercise>, ExercismClientError>) -> Void) {
        onExercises?(track, completed)
    }

    func validateToken(completed: @escaping (Result<ValidateTokenResponse, ExercismClientError>) -> Void) {
        onValidateToken?(completed)
    }

    func solutions(for track: String?, withStatus status: SolutionStatus?, mentoringStatus: MentoringStatus?,
                   completed: @escaping (Result<ListResponse<Solution>, ExercismClientError>) -> Void) {
        onSolutions?(completed)
    }

    func downloadSolution(with id: String, for track: String, exercise: String,
                          completed: @escaping (Result<ExerciseDocument, ExercismClientError>) -> Void) {
        onDownloadSolution?(track, exercise, completed)
    }

    func initialSolution(for track: String, completed: @escaping (Result<InitialFiles, ExercismClientError>) -> Void) {
        onInitialSolution?(track, completed)
    }

    func getIterations(for solutionId: String,
                       completed: @escaping (Result<IterationResponse, ExercismClientError>) -> Void) {
        onGetIterations?(solutionId, completed)
    }

    func badges(completed: @escaping (Result<ListResponse<Badge>, ExercismClientError>) -> Void) {
        onGetBadges?(completed)
    }

    func getTestRun(withLink link: String,
                    completed: @escaping (Result<TestRunResponse, ExercismClientError>) -> Void) {
        onGetTestRun?(link, completed)
    }

    func submitSolution(withLink link: String,
                        completed: @escaping (Result<SubmitSolutionResponse, ExercismClientError>) -> Void) {
        onSubmitSolution?(link, completed)
    }

    func completeSolution(for solution: String, publish: Bool, iteration: Int?,
                          completed: @escaping (Result<CompletedSolution, ExercismClientError>) -> Void) {
        onCompleteSolution?(solution, completed)
    }

    func runTest(for solution: String, with contents: [SolutionFileData],
                 completed: @escaping (Result<TestSubmission, ExercismClientError>) -> Void) {
        onRunTest?(solution, contents, completed)
    }
}

//
//  MockFetcher.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import Foundation
import ExercismSwift
import Exercode

final class MockFetcher: FetchingProtocol {
    private let client: MockExercismClient

    init(client: MockExercismClient) {
        self.client = client
    }

    func getTracks() async throws(ExercismClientError) -> [Track] {
        try await client.tracks().results
    }

    func getExercises(_ track: Track) async throws(ExercismClientError) -> [Exercise] {
        try await client.exercises(for: track.slug).results
    }

    func getSolutions(_ track: Track) async throws(ExercismClientError) -> [Solution] {
        try await client.solutions(for: track.slug, withStatus: nil, mentoringStatus: nil).results
    }

    func revertToStart(_ solutionId: String) async throws(ExercismClientError) -> InitialFiles {
        try await client.initialSolution(for: solutionId)
    }

    func getIterations(_ solutionId: String) async throws(ExercismClientError) -> [Iteration] {
        try await client.getIterations(for: solutionId).iterations
    }

    func downloadSolutions(_ track: String, _ exercise: String) async throws(ExercismClientError) -> ExerciseDocument {
        try await client.downloadSolution(with: "mock-id", for: track, exercise: exercise)
    }

    func runTest(_ solutionId: String,
                 contents: [SolutionFileData]) async throws(ExercismClientError) -> TestSubmission {
        try await client.runTest(for: solutionId, with: contents)
    }

    func getTestRun(_ link: String) async throws(ExercismClientError) -> TestRunResponse {
        try await client.getTestRun(withLink: link)
    }

    func submitSolution(_ submissionLink: String) async throws(ExercismClientError) -> SubmitSolutionResponse {
        try await client.submitSolution(withLink: submissionLink)
    }

    func completeSolution(_ solutionId: String,
                          publish: Bool,
                          iterationIdx: Int?) async throws(ExercismClientError) -> CompletedSolution {
        try await client.completeSolution(for: solutionId, publish: publish, iteration: iterationIdx)
    }
}

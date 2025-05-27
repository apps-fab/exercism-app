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

    func getTracks() async throws -> [Track] {
        try await withCheckedThrowingContinuation { continuation in
            client.tracks { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getExercises(_ track: ExercismSwift.Track) async throws -> [Exercise] {
        try await withCheckedThrowingContinuation { continuation in
            client.exercises(for: track.slug) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getSolutions(_ track: ExercismSwift.Track) async throws -> [Solution] {
        try await withCheckedThrowingContinuation { continuation in
            client.solutions(for: track.slug, withStatus: nil, mentoringStatus: nil) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func revertToStart(_ solutionId: String) async throws -> InitialFiles {
        try await withCheckedThrowingContinuation { continuation in
            client.initialSolution(for: solutionId) { result in
                switch result {
                case .success(let files):
                    continuation.resume(returning: files)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getIterations(_ solutionId: String) async throws -> [Iteration] {
        try await withCheckedThrowingContinuation { continuation in
            client.getIterations(for: solutionId) { result in
                switch result {
                case .success(let iterations):
                    continuation.resume(returning: iterations.iterations)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func downloadSolutions(_ track: String, _ exercise: String) async throws -> ExerciseDocument {
        try await withCheckedThrowingContinuation { continuation in
            client.downloadSolution(with: "mock-id", for: track, exercise: exercise) { result in
                switch result {
                case .success(let document):
                    continuation.resume(returning: document)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func runTest(_ solutionId: String, contents: [SolutionFileData]) async throws -> TestSubmission {
        try await withCheckedThrowingContinuation { continuation in
            client.runTest(for: solutionId, with: contents) { result in
                switch result {
                case .success(let document):
                    continuation.resume(returning: document)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getTestRun(_ link: String) async throws -> TestRunResponse {
        try await withCheckedThrowingContinuation { continuation in
            client.getTestRun(withLink: link) { result in
                switch result {
                case .success(let testRun):
                    continuation.resume(returning: testRun)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func submitSolution(_ submissionLink: String) async throws -> SubmitSolutionResponse {
        try await withCheckedThrowingContinuation { continuation in
            client.submitSolution(withLink: submissionLink) { result in
                switch result {
                case .success(let submitResponse):
                    continuation.resume(returning: submitResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func completeSolution(_ solutionId: String, publish: Bool, iterationIdx: Int?) async throws -> CompletedSolution {
        try await withCheckedThrowingContinuation { continuation in
            client.completeSolution(for: solutionId, publish: false, iteration: nil) { result in
                switch result {
                case .success(let submitResponse):
                    continuation.resume(returning: submitResponse)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

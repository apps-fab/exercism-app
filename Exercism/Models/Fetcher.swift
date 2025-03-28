//
//  Fetcher.swift
//  Exercism
//
//  Created by Angie Mugo on 17/03/2023.
//

import ExercismSwift

actor Fetcher {
    private var client: ExercismClient {
        let token = ExercismKeychain.shared.get(for: "token")
        return ExercismClient(apiToken: token ?? "")
    }

    func getTracks() async throws -> [Track] {
        return try await withCheckedThrowingContinuation { continuation in
            client.tracks { tracks in
                switch tracks {
                case .success(let tracks):
                    continuation.resume(returning: tracks.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getExercises(_ track: Track) async throws -> [Exercise] {
        return try await withCheckedThrowingContinuation { continuation in
            client.exercises(for: track.slug) { result in
                switch result {
                case .success(let exerciseList):
                    continuation.resume(returning: exerciseList.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getSolutions(_ track: Track) async throws -> [Solution] {
        return try await withCheckedThrowingContinuation { continuation in
            client.solutions(for: track.slug) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions.results)
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
                case .success(let iterationResponse):
                    continuation.resume(returning: iterationResponse.iterations)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func downloadSolutions(_ track: String, _ exercise: String) async throws -> ExerciseDocument {
        return try await withCheckedThrowingContinuation { continuation in
            client.downloadSolution(for: track, exercise: exercise) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func runTest(_ solutionId: String, contents: [SolutionFileData]) async throws -> TestSubmission {
        return try await withCheckedThrowingContinuation { continuation in
            client.runTest(for: solutionId, with: contents) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getTestRun(_ link: String) async throws -> TestRunResponse {
        return try await withCheckedThrowingContinuation { continuation in
            client.getTestRun(withLink: link) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func submitSolution(_ submissionLink: String) async throws -> SubmitSolutionResponse {
        return try await withCheckedThrowingContinuation { continuation in
            client.submitSolution(withLink: submissionLink) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func completeSolution(_ solutionId: String, publish: Bool, iterationIdx: Int?) async throws -> CompletedSolution {
        try await withCheckedThrowingContinuation { continuation in
            client.completeSolution(for: solutionId,
                                    publish: publish,
                                    iteration: iterationIdx) { result in
                switch result {
                case .success(let solutions):
                    continuation.resume(returning: solutions)
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
                case .success(let solution):
                    continuation.resume(returning: solution)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

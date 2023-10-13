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
            client.runTest(for: solutionId, withFileContents: contents) { result in
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
}

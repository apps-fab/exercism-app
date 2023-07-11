//
//  Fetcher.swift
//  Exercism
//
//  Created by Angie Mugo on 17/03/2023.
//

import ExercismSwift

actor Fetcher {
    private let client: ExercismClient
    
    init() {
        let token = ExercismKeychain.shared.get(for: "token")
        client = ExercismClient(apiToken: token ?? "")
    }
    
    func getTracks() async throws -> [Track] {
        try await withCheckedThrowingContinuation { continuation in
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
        try await withCheckedThrowingContinuation { continuation in
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

    func fetchSolutions(_ track: Track) async throws -> [Solution] {
        try await withCheckedThrowingContinuation { continuation in
            client.solutions(for: track.slug) { result in
                switch result {
                case .success(let solutionList):
                    continuation.resume(returning: solutionList.results)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getIteration(_ solutionId: String) async throws -> Iteration {
        try await withCheckedThrowingContinuation { continuation in
            client.getIteration(for: solutionId) { result in
                switch result {
                case .success(let iteration):
                    continuation.resume(returning: iteration)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

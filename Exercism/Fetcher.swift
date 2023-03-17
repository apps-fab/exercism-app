//
//  Fetcher.swift
//  Exercism
//
//  Created by Angie Mugo on 17/03/2023.
//

import ExercismSwift

actor Fetcher {
    private let client: ExercismClient

    init(client: ExercismClient) {
        self.client = client
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

}

//
//  ExerciseListViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI
import ExercismSwift

enum LoadingState<Value: Sendable> {
    case idle
    case loading
    case success(Value)
    case failure(ExercismClientError)
}

@MainActor
final class ExerciseListViewModel: ObservableObject {
    @Published var state: LoadingState<[Exercise]> = .idle
    private var exercises = [Exercise]()
    private let fetcher = Fetcher()
    private let track: Track

    init(track: Track) {
        self.track = track
        Task { await getExercises(track) }
    }

    func getExercises(_ track: Track) async {
        state = .loading
        do {
            let fetchedExercises = try await fetcher.getExercises(track)
            exercises = fetchedExercises
            state = .success(fetchedExercises)
        } catch let appError as  ExercismClientError {
            state = .failure(appError)
        } catch {
            state = .failure(ExercismClientError.genericError(error))
        }
    }

    func getSolutions(_ track: Track) async throws -> [Solution] {
        return try await fetcher.getSolutions(track)
    }

    func filterExercises(_ searchText: String) {
        let filtered = searchText.isEmpty ? exercises : exercises.filter { $0.slug.lowercased().contains(searchText) }
        state = .success(filtered)
    }
}

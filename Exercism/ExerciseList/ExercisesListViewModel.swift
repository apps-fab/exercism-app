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
    @Published var solutions = [String: Solution]()
    private var exercises = [Exercise]()
    private let fetcher: FetchingProtocol
    private let track: Track

    init(track: Track, fetcher: FetchingProtocol? = nil) {
        self.fetcher = fetcher ?? Fetcher()
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

    func getSolutions(_ track: Track) async throws {
        let solutionsList = try await fetcher.getSolutions(track)
        self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
    }

    func filterExercises(_ searchText: String) {
        let filtered = searchText.isEmpty ? exercises : exercises.filter { $0.slug.lowercased().contains(searchText) }
        state = .success(filtered)
    }

    /// Group exercises by category
    /// - Parameter exercises:
    /// - Returns: [ExerciseCategory: [Exercise]]
    func groupExercises(_ exercises: [Exercise]) -> [ExerciseCategory: [Exercise]] {
        var groupedExercises = [ExerciseCategory: [Exercise]]()
        for category in ExerciseCategory.allCases {
            groupedExercises[category] = filterExercises(by: category, exercises: exercises)
        }
        return groupedExercises
    }

    private func filterExercises(by category: ExerciseCategory, exercises: [Exercise]) -> [Exercise] {
        switch category {
        case .allExercises:
            return exercises
        case .completed:
            return exercises.filter {
                getSolution(for: $0)?.status == .completed || getSolution(for: $0)?.status == .published
            }
        case .inProgress:
            return exercises.filter {
                getSolution(for: $0)?.status == .started || getSolution(for: $0)?.status == .iterated
            }
        case .available:
            return exercises.filter { $0.isUnlocked && getSolution(for: $0) == nil }
        case .locked:
            return exercises.filter { !$0.isUnlocked }
        }
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
}

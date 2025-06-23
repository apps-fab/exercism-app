//
//  ExerciseListViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI
import ExercismSwift
import Combine

enum LoadingState<Value: Sendable> {
    case idle
    case loading
    case success(Value)
    case failure(String)
}

@MainActor
final class ExerciseListViewModel: ObservableObject {
    @Published var state: LoadingState<[Exercise]> = .idle
    @Published var solutions = [String: Solution]()
    @Published var filteredGroupedExercises = [ExerciseCategory: [Exercise]]()
    @Published var searchText = ""
    @Published var selectedCategory: ExerciseCategory = .allExercises

    private var groupedAllExercises = [ExerciseCategory: [Exercise]]()
    private var cancellables = Set<AnyCancellable>()
    private let fetcher: FetchingProtocol
    let track: Track

    init(_ track: Track, _ fetcher: FetchingProtocol? = nil) {
        self.track = track
        self.fetcher = fetcher ?? Fetcher()
        setupCombinedListener()
    }

    private func setupCombinedListener() {
        Publishers.CombineLatest($searchText, $selectedCategory)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText, category in
                self?.handleSearchAndCategory(searchText: searchText, category: category)
            }
            .store(in: &cancellables)
    }

    func loadData() async {
        state = .loading
        do {
            async let fetchedExercises = fetcher.getExercises(track)
            async let fetchedSolutions = fetcher.getSolutions(track)

            let (exercises, solutionsList) = try await (fetchedExercises, fetchedSolutions)
            self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map { ($0.exercise.slug, $0) })

            self.groupedAllExercises = groupExercises(exercises)
            self.filteredGroupedExercises = groupedAllExercises
            state = .success(groupedAllExercises[.allExercises] ?? [])
        } catch let error as ExercismClientError {
            state = .failure(error.description)
        } catch {
            state = .failure("An unknown error occurred.")
        }
    }

    private func handleSearchAndCategory(searchText: String, category: ExerciseCategory) {
        filteredGroupedExercises = makeFilteredGroups(from: groupedAllExercises, searchText: searchText)
        state = .success(filteredGroupedExercises[category] ?? [])
    }

    private func makeFilteredGroups(from grouped: [ExerciseCategory: [Exercise]],
                                    searchText: String) -> [ExerciseCategory: [Exercise]] {
        guard !searchText.isEmpty else { return grouped }

        let query = searchText.lowercased()
        return grouped.mapValues { $0.filter { $0.slug.lowercased().contains(query) } }
    }

    private func groupExercises(_ exercises: [Exercise]) -> [ExerciseCategory: [Exercise]] {
        var grouped = [ExerciseCategory: [Exercise]]()
        for category in ExerciseCategory.allCases {
            grouped[category] = filterExercises(exercises: exercises, by: category)
        }
        return grouped
    }

    private func filterExercises(exercises: [Exercise], by category: ExerciseCategory) -> [Exercise] {
        exercises.filter { exercise in
            switch category {
            case .allExercises:
                return true
            case .completed:
                guard let solution = getSolution(for: exercise) else { return false }
                return solution.isCompleted
            case .inProgress:
                guard let solution = getSolution(for: exercise) else { return false }
                return solution .isInProgress
            case .available:
                return exercise.isUnlocked && getSolution(for: exercise) == nil
            case .locked:
                return !exercise.isUnlocked
            }
        }
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
}

extension Solution {
    var isCompleted: Bool {
        status == .completed || status == .published
    }

    var isInProgress: Bool {
        status == .started || status == .iterated
    }
}

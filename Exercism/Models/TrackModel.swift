//
//  TrackModel.swift
//  Exercism
//
//  Created by Angie Mugo on 06/03/2023.
//

import ExercismSwift
import Foundation

@MainActor
final class TrackModel: ObservableObject {
    private var unfilteredTracks = [Track]()
    var unfilteredExercises = [Exercise]()
    var groupedExercises = [ExerciseCategory: [Exercise]]()
    private let fetcher: Fetcher
    private var solutions = [String: Solution]()

    static let shared = TrackModel()

    init() {
        self.fetcher = Fetcher()
    }

    func getTracks() async throws -> [Track] {
        let fetchedTracks = try await fetcher.getTracks()
        self.unfilteredTracks = fetchedTracks
        return fetchedTracks
    }

    func getExercises(_ track: Track) async throws -> [Exercise] {
        let fetchedExercises = try await fetcher.getExercises(track)
        let solutions = try await getSolutions(track)
        getGroupedSolutions(solutions)
        self.unfilteredExercises = fetchedExercises
        groupExercise()
        return fetchedExercises
    }

    func getSolutions(_ track: Track) async throws -> [Solution] {
        return try await fetcher.getSolutions(track)
    }

    func filterTracks(_ searchText: String) -> [Track] {
        let tracks: [Track] =  searchText.isEmpty ? unfilteredTracks : unfilteredTracks.filter { $0.title.lowercased().contains(searchText) }
        return tracks
    }

    func filterExercises(_ searchText: String) -> [Exercise] {
        let exercises: [Exercise] =  searchText.isEmpty ? unfilteredExercises : unfilteredExercises.filter { $0.slug.lowercased().contains(searchText) }
        return exercises
    }

    func filterTags(_ tags: Set<String>) -> [Track] {
        let tracks: [Track] =  unfilteredTracks.filter { $0.tags.contains(tags) }
        return tracks
    }

    func sortTracks() -> [Track] {
        unfilteredTracks.sorted(by: { $0.lastTouchedAt ?? Date() < $1.lastTouchedAt ?? Date() })
    }

    /// Group exercises by category
    /// - Parameter exercises:
    /// - Returns: [ExerciseCategory: [Exercise]]
    func filterExercise(by category: ExerciseCategory) -> [Exercise] {
        let exercises = unfilteredExercises
        switch category {
        case .AllExercises:
            return exercises
        case .Completed:
            return exercises.filter { getSolution(for: $0)?.status == .completed || getSolution(for: $0)?.status == .published }
        case .InProgress:
            return exercises.filter { getSolution(for: $0)?.status == .started || getSolution(for: $0)?.status == .iterated }
        case .Available:
            return exercises.filter { $0.isUnlocked && getSolution(for: $0) == nil }
        case .locked:
            return exercises.filter { !$0.isUnlocked }
        }
    }

    func groupExercise() {
        var groupedExercises = [ExerciseCategory: [Exercise]]()
        for category in ExerciseCategory.allCases {
            groupedExercises[category] = filterExercise(by: category)
        }
        self.groupedExercises = groupedExercises
    }

    func getGroupedSolutions(_ solutionsList: [Solution]) {
        self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
}

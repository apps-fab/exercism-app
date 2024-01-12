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
    private var unfilteredExercises = [Exercise]()
    private let fetcher = Fetcher()
    static let shared = TrackModel()

    func getTracks() async throws -> [Track] {
        let fetchedTracks = try await fetcher.getTracks()
        self.unfilteredTracks = fetchedTracks
        return fetchedTracks
    }

    func getExercises(_ track: Track) async throws -> [Exercise] {
        let fetchedExercises = try await fetcher.getExercises(track)
        self.unfilteredExercises = fetchedExercises
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
        unfilteredTracks.sorted(by: { $0.lastTouchedAt ?? Date() > $1.lastTouchedAt ?? Date() })
    }
    
    func getIterations(for solutionId: String) async throws -> [Iteration] {
        try await fetcher.getIterations(solutionId)
    }
    
    func completeSolution(for solutionId: String, publish: Bool, iterationIdx: Int?) async throws -> CompletedSolution {
        try await fetcher.completeSolution(solutionId, publish: publish, iterationIdx: iterationIdx)
    }
}

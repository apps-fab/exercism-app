//
//  TrackModel.swift
//  Exercism
//
//  Created by Angie Mugo on 06/03/2023.
//

import ExercismSwift
import Foundation

enum FilterState {
    case SearchTracks(query: String)
    case SearchExercises(query: String)
    case FilterTags(tags: Set<String>)
    case SortTracks
}

@MainActor
final class TrackModel: ObservableObject {
    private var unfilteredTracks = [Track]()
    private var unfilteredExercises = [Exercise]()
    private let fetcher: Fetcher

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
        self.unfilteredExercises = fetchedExercises
        return fetchedExercises
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

//    func toggleSelection(_ selection: ExerciseCategory) {
//        // Not the correct parameters
//        switch selection {
//        case .AllExercises:
//            exercises = .success(unfilteredExercises)
//        case .Available:
//            exercises = .success(unfilteredExercises.filter { $0.isUnlocked })
//        case .Completed:
//            exercises = .success(unfilteredExercises.filter { $0.isRecommended })
//        case .InProgress:
//            exercises = .success(unfilteredExercises.filter { $0.isRecommended })
//        case .locked:
//            exercises = .success(unfilteredExercises.filter { !$0.isUnlocked })
//        }
//    }
}

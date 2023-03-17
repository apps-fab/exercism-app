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

enum ViewState {
    case Idle
    case loading
    case Loaded((joinedTracks: [Track], unjoinedTracks: [Track]))
    case Error(ExercismClientError)
}

@MainActor
final class TrackModel: ObservableObject {
    @Published private(set) var tracks = [Track]()
    @Published private(set) var exercises = [Exercise]()
    private var unfilteredTracks = [Track]()
    private var unfilteredExercises = [Exercise]()
    private let coordinator: AppCoordinator
    private let fetcher: Fetcher

    init(fetcher: Fetcher, coordinator: AppCoordinator) {
        self.fetcher = fetcher
        self.coordinator = coordinator
    }

    func tracks() async throws {
        tracks = try await fetcher.getTracks()
        self.unfilteredTracks = self.tracks
    }

    func exercises(for track: Track) async throws {
        exercises = try await fetcher.getExercises(track)
        self.unfilteredExercises = self.exercises
    }

    func filter(_ type: FilterState) {
        switch type {
        case .SearchTracks(let searchText):
            tracks = searchText.isEmpty ? unfilteredTracks : unfilteredTracks.filter { $0.title.lowercased().contains(searchText) }

        case .SearchExercises(let searchText):
            exercises = exercises.filter { $0.slug.contains(searchText) }

        case .FilterTags(let tags):
            tracks = unfilteredTracks.filter { $0.tags.contains(tags) }

        case .SortTracks:
            tracks = tracks.sorted(by: { $0.lastTouchedAt ?? Date() < $1.lastTouchedAt ?? Date() })
        }
    }


    func toggleSelection(_ selection: ExerciseCategory) {
        // Not the correct parameters
        switch selection {
        case .AllExercises:
            exercises = unfilteredExercises
        case .Available:
            exercises = unfilteredExercises.filter { $0.isUnlocked }
        case .Completed:
            exercises = unfilteredExercises.filter { $0.isRecommended }
        case .InProgress:
            exercises = unfilteredExercises.filter { $0.isRecommended }
        case .locked:
            exercises = unfilteredExercises.filter { !$0.isUnlocked }
        }
    }
}

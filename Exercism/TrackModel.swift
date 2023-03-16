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
    private let client: ExercismClient
    private let coordinator: AppCoordinator

    init(client: ExercismClient, coordinator: AppCoordinator) {
        self.client = client
        self.coordinator = coordinator
    }

    @discardableResult
    func getTracks() async throws -> [Track] {
        try await withCheckedThrowingContinuation { continuation in
            client.tracks { tracks in
                switch tracks {
                case .success(let tracks):
                    continuation.resume(returning: tracks.results)
                    self.tracks = tracks.results
                    self.unfilteredTracks = self.tracks
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    @discardableResult
    func getExercises(_ track: Track) async throws -> [Exercise] {
        try await withCheckedThrowingContinuation { continuation in
            client.exercises(for: track.slug) { result in
                switch result {
                case .success(let exerciseList):
                    continuation.resume(returning: exerciseList.results)
                    self.exercises = exerciseList.results
                    self.unfilteredExercises = self.exercises
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
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

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
    @Published var tracks = [Track]()
    @Published var exercises = [Exercise]()
    private var unfilteredTracks = [Track]()
    private var unfilteredExercises = [Exercise]()
    private var client: ExercismClient

    init(client: ExercismClient) {
        self.client = client
    }

    @discardableResult
    func getTracks() async -> [Track] {
        await withCheckedContinuation { continuation in
            client.tracks { tracks in
                switch tracks {
                case .success(let tracks):
                    continuation.resume(returning: tracks.results)
                    self.tracks = tracks.results
                    self.unfilteredTracks = self.tracks
                case .failure(let error):
                    print("This is the error: \(error)")
                }
            }
        }
    }

    @discardableResult
    func getExercises(_ track: Track) async -> [Exercise] {
        await withCheckedContinuation { continuation in
            client.exercises(for: track.slug) { result in
                switch result {
                case .success(let exerciseList):
                    continuation.resume(returning: exerciseList.results)
                    self.exercises = exerciseList.results
                    self.unfilteredExercises = self.exercises
                case .failure(let error):
                    print("This is \(error)")
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

    func goToTrack(_ track: Track, _ coordinator: AppCoordinator) {
        if track.isJoined {
            coordinator.goToTrack(track)
        } else {
            // show alert to join track on web or show join track in app
        }
    }

    func goToExercise(_ track: Track, _ exercise: Exercise, _ coordinator: AppCoordinator) {
        if exercise.isUnlocked {
            coordinator.goToEditor(track.slug, exercise.slug)
        } else {
            // show alert to user
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

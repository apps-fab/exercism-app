//
//  TrackModel.swift
//  Exercism
//
//  Created by Angie Mugo on 06/03/2023.
//

import ExercismSwift
import Foundation

@MainActor
final class TrackViewModel: ObservableObject {
    @Published var state: LoadingState<[Track]> = .idle
    private var tracks = [Track]()
    private let fetcher = Fetcher()

    func getTracks() async {
        state = .loading
        do {
            let fetchedTracks = try await fetcher.getTracks()
            state = .success(fetchedTracks)
        } catch {
            state = .failure(error as! ExercismClientError)
        }
    }

    func filterTracks(_ searchText: String) {
        let filtered =  searchText.isEmpty ?
        tracks : tracks.filter { $0.title.lowercased().contains(searchText) }
        state = .success(filtered)
    }

    func filterTags(_ tags: Set<String>) {
        let filtered =  tracks.filter { $0.tags.contains(tags) }
        state = .success(filtered)
    }

    func sortTracks() {
        let sorted = tracks.sorted(by: { $0.lastTouchedAt ?? Date() > $1.lastTouchedAt ?? Date() })
        state = .success(sorted)
    }
}

@MainActor
final class ExerciseListViewModel: ObservableObject {
    @Published var state: LoadingState<[Exercise]> = .idle
    private var exercises = [Exercise]()
    private let fetcher = Fetcher()
    private let track: Track

    init(track: Track) {
        self.track = track
    }

    func getExercises(_ track: Track) async {
        state = .loading
        do {
            let fetchedExercises = try await fetcher.getExercises(track)
            exercises = fetchedExercises
            state = .success(fetchedExercises)
        } catch {
            state = .failure(error as! ExercismClientError)
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

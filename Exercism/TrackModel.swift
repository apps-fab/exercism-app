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
class TrackModel: ObservableObject {
    private var client: ExercismClient
    @Published var tracks = [Track]()
    @Published var exercises = [Exercise]()
    var unfilteredTracks = [Track]()

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
}

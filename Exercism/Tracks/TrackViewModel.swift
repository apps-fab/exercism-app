//
//  TrackViewModel.swift
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
    private let fetcher: FetchingProtocol

    init(fetcher: FetchingProtocol? = nil) {
        self.fetcher = fetcher ?? Fetcher()
        Task {
            await getTracks()
        }
    }

    func getTracks() async {
        state = .loading
        do {
            let fetchedTracks = try await fetcher.getTracks()
            tracks = fetchedTracks
            state = .success(fetchedTracks)
        } catch let appError as ExercismClientError {
            state = .failure(appError)
        } catch {
            state = .failure(ExercismClientError.genericError(error))
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

//
//  TracksViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import ExercismSwift
import Foundation

enum Keys: String {
    case token
}

enum ViewState {
    case Idle
    case loading
    case Loaded((joinedTracks: [Track], unjoinedTracks: [Track]))
    case Error(ExercismClientError)
}

class TracksViewModel: ObservableObject {
    @Published private(set) var state = ViewState.Idle
    let coordinator: AppCoordinator
    var joinedTracks = [Track]()
    var unjoinedTracks = [Track]()

    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }

    func fetchTracks() {
        state = .Idle
        // this should never happen since we never get to this screen without a token
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else
        { return }
        let client = ExercismClient(apiToken: token)
        client.tracks { response in
            switch response {
            case .success(let fetchedTracks):
                self.joinedTracks = fetchedTracks.results.filter { $0.isJoined }
                self.unjoinedTracks = fetchedTracks.results.filter { !$0.isJoined}
                self.state = ViewState.Loaded((joinedTracks: self.joinedTracks, unjoinedTracks: self.unjoinedTracks))
            case .failure(let error):
                self.state = ViewState.Error(error)
            }
        }
    }

    func filter(_ filters: Set<String>) {
        if filters.isEmpty {
            state = .Loaded((joinedTracks, unjoinedTracks))
        } else {
            let joined = joinedTracks.filter { $0.tags.contains(filters) }
            let unjoined = unjoinedTracks.filter { $0.tags.contains(filters) }
            state = .Loaded((joined, unjoined))
        }
    }

    func search(_ searchText: String) {
        if searchText.isEmpty {
            state = .Loaded((joinedTracks, unjoinedTracks))
        } else {
            let joined = joinedTracks.filter { $0.title.lowercased().contains(searchText) }
            let unjoined = unjoinedTracks.filter { $0.title.lowercased().contains(searchText) }
            state = .Loaded((joined, unjoined))
        }
    }

    func sort() {
        let joined = joinedTracks.sorted(by:  { $0.lastTouchedAt ?? Date() < $1.lastTouchedAt ?? Date() })
        let unjoined = unjoinedTracks.sorted(by:  { $0.lastTouchedAt ?? Date() < $1.lastTouchedAt ?? Date() })
        state = .Loaded((joined, unjoined))
    }

    func goToExercises(_ track: Track) {
        if track.isJoined {
            coordinator.goToTrack(track)
        } else {
            // show alert to join track on web or show join track in app
        }
    }
}

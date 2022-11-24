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

class TracksViewModel: ObservableObject {
    @Published var tracks = [Track]()

    var joinedTracks: [Track] {
        tracks.filter { $0.isJoined }
    }

    var unJoinedTracks: [Track] {
        tracks.filter { !$0.isJoined }
    }

    func fetchTracks() {
        // this should never happen since we never get to this screen without a token
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else
        { return }
        let client = ExercismClient(apiToken: token)
        client.tracks { response in
            switch response {
            case .success(let fetchedTracks):
                self.tracks = fetchedTracks.results
            case .failure(let error):
                // implement error handling
                print("This is the error: \(error)")
            }
        }
    }

    func filter(_ filters: Set<String>) {
        self.tracks = tracks.filter { $0.tags.contains(filters) }

    }

    func search(_ searchText: String) {
        self.tracks = tracks.filter { $0.title.contains(searchText) }
    }
}

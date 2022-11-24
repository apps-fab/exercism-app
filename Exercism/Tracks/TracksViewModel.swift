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
    @Published var filteredTracks = [Track]()

    var joinedTracks: [Track] {
        filteredTracks.filter { $0.isJoined }
    }

    var unJoinedTracks: [Track] {
        filteredTracks.filter { !$0.isJoined }
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
                self.filteredTracks = fetchedTracks.results
            case .failure(let error):
                // implement error handling
                print("This is the error: \(error)")
            }
        }
    }

    func filter(_ filters: Set<String>) {
        self.filteredTracks = tracks.filter { $0.tags.contains(filters) }
    }

    func search(_ searchText: String) {
        let filtered = tracks.filter { $0.title.lowercased().contains(searchText) }
        self.filteredTracks = searchText.isEmpty ? tracks : filtered
    }
}

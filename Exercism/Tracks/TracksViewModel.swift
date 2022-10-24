//
//  TracksViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import ExercismSwift
import Foundation

class TracksViewModel: ObservableObject {
    @Published var tracks = [Track]()

    init() {
        fetchTracks()
    }

    var joinedTracks: [Track] {
        tracks.filter { $0.isJoined }
    }

    var unJoinedTracks: [Track] {
        tracks.filter { !$0.isJoined }
    }

    func fetchTracks()  {
        let client = ExercismClient(apiToken: ExercismKeychain.shared.get(for: "token") ?? "")
        client.tracks { response in
            switch response {
            case .success(let fetchedTracks):
                self.tracks = fetchedTracks.results
            case .failure(let error):
                print("These are the errors: \(error)")
            }
        }
    }
}

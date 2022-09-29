//
//  TracksViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import ExercismSwift
import Foundation

class TracksViewModel: ObservableObject {
    @Published var joinedTracks = [Track]()
    @Published var unJoinedTracks = [Track]()

    func fetchTracks() {
        let client = ExercismClient(apiToken: ExercismKeychain.shared.get(for: "token") ?? "")
        client.tracks { response in
            switch response {
            case .success(let fetchedTracks):
                var sortedArray = fetchedTracks.results
                var joinedArray = [Track]()
                // This only works for as long as the array is sorted with the joined prefixed
                for track in sortedArray {
                    if track.isJoined {
                        joinedArray.append(track)
                        sortedArray.remove(at: 0)
                    } else {
                        self.joinedTracks = joinedArray
                        self.unJoinedTracks = sortedArray
                        break
                    }
                }

            case .failure(let error):
                print("These are the errors: \(error)")
            }
        }
    }
}

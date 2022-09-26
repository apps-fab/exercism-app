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

    func fetchTracks() {
        let client = ExercismClient(apiToken: "502b615d-d14b-44d1-907f-950bcacb3621")
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

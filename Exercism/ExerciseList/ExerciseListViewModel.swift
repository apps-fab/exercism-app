//
//  ExerciseListViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import Foundation
import ExercismSwift

class ExerciseListViewModel: ObservableObject {
    var trackName: String
    @Published var exercisesList = [Exercise]()

    init(trackName: String) {
        self.trackName = trackName
    }

    func fetchExerciseList() {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else
        { return }
        let client = ExercismClient(apiToken: token)
        client.exercises(for: trackName) { result in
            switch result {
            case .success(let exerciseList):
                self.exercisesList = exerciseList.results
            case .failure(let error):
                print("This is \(error)")
            }
        }

    }
}

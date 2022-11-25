//
//  ExerciseListViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import Foundation
import ExercismSwift

class ExerciseListViewModel: ObservableObject {
    @Published var exercisesList = [Exercise]()
    let trackName: String
    let coordinator: AppCoordinator

    init(trackName: String, coordinator: AppCoordinator) {
        self.trackName = trackName
        self.coordinator = coordinator
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

    func goToExercise(_ exercise: String) {
        coordinator.goToEditor(trackName, exercise)
    }
}

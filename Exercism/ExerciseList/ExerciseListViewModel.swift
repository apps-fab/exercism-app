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
    private var allExercises = [Exercise]()
    let track: Track
    let coordinator: AppCoordinator

    init(track: Track, coordinator: AppCoordinator) {
        self.track = track
        self.coordinator = coordinator
    }

    func fetchExerciseList() {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else
        { return }
        let client = ExercismClient(apiToken: token)
        client.exercises(for: track.slug) { result in
            switch result {
            case .success(let exerciseList):
                self.allExercises = exerciseList.results
                self.exercisesList = exerciseList.results
            case .failure(let error):
                print("This is \(error)")
            }
        }
    }

    func filter(_ searchText: String) {
        exercisesList = allExercises.filter { $0.slug.contains(searchText)}
    }

    func toggleSelection(_ selection: ExerciseCategory) {
        // Not the correct parameters
        switch selection {
        case .AllExercises:
            exercisesList = allExercises
        case .Available:
            exercisesList = allExercises.filter { $0.isUnlocked }
        case .Completed:
            exercisesList = allExercises.filter { $0.isRecommended }
        case .InProgress:
            exercisesList = allExercises.filter { $0.isRecommended }
        case .locked:
            exercisesList = allExercises.filter { !$0.isUnlocked }
        }
    }

    func goToExercise(_ exercise: Exercise) {
        if exercise.isUnlocked {
            coordinator.goToEditor(track.slug, exercise.slug)
        } else {
            // show alert to user 
        }
    }
}

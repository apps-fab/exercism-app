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
    private var solutions = [String: Solution]()
    let trackName: String
    let coordinator: AppCoordinator

    init(trackName: String, coordinator: AppCoordinator) {
        self.trackName = trackName
        self.coordinator = coordinator
    }

    func fetchExerciseList() {
        guard let client = getClient() else {
            return
        }
        client.exercises(for: trackName) { result in
            switch result {
            case .success(let exerciseList):
                self.fetchSolutions { [weak self] in
                    guard let self else {
                        return
                    }
                    self.allExercises = exerciseList.results
                    self.exercisesList = exerciseList.results
                }
            case .failure(let error):
                print("Error fetching exercises \(error)")
            }
        }
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }

    private func fetchSolutions(completion: @escaping () -> Void) {
        guard let client = getClient() else {
            return
        }
        client.solutions(for: trackName) { result in
            switch result {
            case .success(let solutionList):
                self.solutions = Dictionary(uniqueKeysWithValues: solutionList.results.map({($0.exercise.slug, $0)}))
                completion()
            case .failure(let error):
                print("Error fetching solutions \(error)")
            }
        }
    }

    func filter(_ searchText: String) {
        exercisesList = allExercises.filter {
            $0.slug.contains(searchText)
        }
    }

    func toggleSelection(_ selection: ExerciseCategory) {
        // Not the correct parameters
        switch selection {
        case .AllExercises:
            exercisesList = allExercises
        case .Available:
            exercisesList = allExercises.filter {
                $0.isUnlocked
            }
        case .Completed:
            exercisesList = allExercises.filter {
                $0.isRecommended
            }
        case .InProgress:
            exercisesList = allExercises.filter {
                $0.isRecommended
            }
        case .locked:
            exercisesList = allExercises.filter {
                !$0.isUnlocked
            }
        }
    }

    func goToExercise(_ exercise: Exercise) {
        if exercise.isUnlocked {
            coordinator.goToEditor(trackName, exercise.slug)
        } else {
            // show alert to user 
        }
    }

    private func getClient() -> ExercismClient? {
        guard let token = ExercismKeychain.shared.get(for: Keys.token.rawValue) else {
            return nil
        }

        return ExercismClient(apiToken: token)
    }
}

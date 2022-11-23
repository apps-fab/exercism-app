//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI

struct ExercisesList: View {
    @StateObject var viewModel: ExerciseListViewModel

    var body: some View {
            List(viewModel.exercisesList, id: \.self) { exercise in
                Button {
                    viewModel.goToExercise(exercise.slug)
                } label: {
                    Text(exercise.slug)
                }
            }.task {
                viewModel.fetchExerciseList()
            }
        }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(viewModel: ExerciseListViewModel(trackName: "Python", coordinator: AppCoordinator()))
    }
}

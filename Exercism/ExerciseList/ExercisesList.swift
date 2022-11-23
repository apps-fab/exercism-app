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
        NavigationSplitView {
            List(viewModel.exercisesList, id: \.self) { exercise in
                Text(exercise.slug)
            }.task {
                viewModel.fetchExerciseList()
            }
        } detail: {
            ExerciseEditorWindowView()
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(viewModel: ExerciseListViewModel(trackName: "Python"))
    }
}

//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI

enum ExerciseCategory : String, CaseIterable, Identifiable {
    case AllExercises
    case Completed
    case InProgress
    case Available
    case locked

    var id: Self { return self }

}

struct ExercisesList: View {
    @StateObject var viewModel: ExerciseListViewModel
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var contentCategory: _Content = .Exercises
    @State private var resultsCount = 0
    @State private var searchText = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack {
                ExerciseHeaderView(track: viewModel.track,
                                   contentSelection: $contentCategory,
                                   exerciseCategory: $exerciseCategory,
                                   searchText: $searchText,
                                   resultCount: $resultsCount)
                Divider().frame(height: 2)
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.exercisesList, id: \.self) { exercise in
                        Button {
                            viewModel.goToExercise(exercise)
                        } label: {
                            ExerciseGridView(exercise: exercise)
                        }.buttonStyle(.plain)
                    }
                }
            }.task {
                viewModel.fetchExerciseList()
                resultsCount = viewModel.exercisesList.count
            }
        }.onChange(of: searchText) { newValue in
            viewModel.filter(searchText)
        }
        .onChange(of: exerciseCategory) { newValue in
            viewModel.toggleSelection(newValue)
        }
        .onChange(of: contentCategory) { newValue in
//            viewModel.toggleSelection(newValue)
        }
    }
}

//struct ExercisesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExercisesList(viewModel: ExerciseListViewModel(trackName: , coordinator: AppCoordinator()))
//    }
//}

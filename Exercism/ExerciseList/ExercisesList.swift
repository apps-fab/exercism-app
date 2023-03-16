//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI
import ExercismSwift

enum ExerciseCategory : String, CaseIterable, Identifiable {
    case AllExercises
    case Completed
    case InProgress
    case Available
    case locked

    var id: Self { return self }
}

struct ExercisesList: View {
    @EnvironmentObject private var model: TrackModel
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var contentCategory: _Content = .Exercises
    @State private var searchText = ""
    @StateObject var coordinator: AppCoordinator
    var track: Track
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack {
                ExerciseHeaderView(contentSelection: $contentCategory,
                                   exerciseCategory: $exerciseCategory,
                                   searchText: $searchText,
                                   resultCount: model.exercises.count,
                                   track: track)
                Divider().frame(height: 2)
                LazyVGrid(columns: columns) {
                    ForEach(model.exercises, id: \.self) { exercise in
                        Button {
                            model.goToExercise(track, exercise, coordinator)
                        } label: {
                            ExerciseGridView(exercise: exercise)
                        }.buttonStyle(.plain)
                    }
                }
            }.task {
                await model.getExercises(track)
            }
        }.onChange(of: searchText) { newValue in
            model.filter(.SearchExercises(query: newValue))
        }
        .onChange(of: exerciseCategory) { newValue in
            model.toggleSelection(newValue)
        }
        .onChange(of: contentCategory) { newValue in
            // need to implement
        }
    }
}

//struct ExercisesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExercisesList(viewModel: ExerciseListViewModel(trackName: , coordinator: AppCoordinator()))
//    }
//}

//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI

enum ExerciseCategory : String, CaseIterable {
    case AllExercises
    case Completed
    case InProgress
    case Available
    case locked
}

struct ExercisesList: View {
    @StateObject var viewModel: ExerciseListViewModel
    @State var segmentationSelection: ExerciseCategory = .AllExercises
    @State private var searchText = ""
    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search language filters", text: $searchText)
                        .textFieldStyle(.plain)
                        .onSubmit {
                            viewModel.filter(searchText)
                        }
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(.black))
                Picker("Some Picker", selection: $segmentationSelection) {
                    ForEach(ExerciseCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }.pickerStyle(.segmented)
                    .padding()
                    .onChange(of: segmentationSelection) { newValue in
                        viewModel.toggleSelection(segmentationSelection)
                    }
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.exercisesList, id: \.self) { exercise in
                        Button {
                            viewModel.goToExercise(exercise.slug)
                        } label: {
                            ExerciseGridView(exercise: exercise)
                        }.buttonStyle(.plain)
                    }
                }
            }.task {
                viewModel.fetchExerciseList()
            }
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(viewModel: ExerciseListViewModel(trackName: "Python", coordinator: AppCoordinator()))
    }
}
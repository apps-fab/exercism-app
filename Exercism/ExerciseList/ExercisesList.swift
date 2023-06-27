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
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var model: TrackModel
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var searchText = ""
    @State var track: Track
    @State var asyncModel: AsyncModel<[Exercise]>
    @State private var solutions = [String: Solution]()
    @FocusState private var fieldFocused: Bool

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]

    var body: some View {
        AsyncResultView(source: asyncModel) { exercises in
                exerciseListView(exercises)
        }.onChange(of: searchText) { newValue in
            asyncModel.filterOperations  = { self.model.filterExercises(newValue) }
        }.onChange(of: exerciseCategory) { newValue in
            // implement this
        }.task {
            let solutionsList = try! await model.getSolutions(track) // we need to handle this error
            self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
        }.onAppear {
            fieldFocused = false
        }
    }

    @ViewBuilder
    func exerciseListView(_ exercises: [Exercise]) -> some View {
        ScrollView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField("Search by title", text: $searchText)
                            .textFieldStyle(.plain)
                    }.padding()
                        .roundEdges(lineColor: fieldFocused ? .purple : .gray)
                        .focused($fieldFocused)
                    CustomPicker(selected: $exerciseCategory) {
                        HStack {
                            ForEach(ExerciseCategory.allCases) { option in
                                Text("\(option.rawValue) (\(exercises.count))")
                                    .padding()
                                    .frame(minWidth: 140, maxHeight: 40)
                                    .roundEdges(backgroundColor: option == exerciseCategory ? Color.gray : .clear, lineColor: .clear)
                                    .onTapGesture {
                                        exerciseCategory = option
                                    }
                            }
                        }
                    }.padding()
                }.padding()
                .background(Color("darkBackground"))
                Divider().frame(height: 2)
                LazyVGrid(columns: columns) {
                    ForEach(exercises, id: \.self) { exercise in
                        Button {
                            coordinator.goToEditor(track.slug, exercise.slug)
                        } label: {
                            ExerciseGridView(exercise: exercise, solution: getSolution(for: exercise))
                        }.buttonStyle(.plain)
                    }
                }.if(exercises.isEmpty) { _ in
                    EmptyStateView {
                        searchText = ""
                    }
                }
            }
        }
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(track: PreviewData.shared.getTrack().first!, asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
    }
}

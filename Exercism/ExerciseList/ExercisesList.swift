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
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var searchText = ""
    @State var track: Track
    @State var asyncModel: AsyncModel<[Exercise]>
    @State private var solutions = [String: Solution]()
    @FocusState private var fieldFocused: Bool
    let model = TrackModel.shared

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]
    
    var body: some View {
        AsyncResultView(source: asyncModel) { exercises in
            exerciseListView(exercises)
        }.onChange(of: searchText) { newValue in
            asyncModel.filterOperations  = { TrackModel.shared.filterExercises(newValue) }
        }.onChange(of: exerciseCategory) { newValue in
            asyncModel.filterOperations = {
                model.groupedExercises[newValue] ?? model.unfilteredExercises
            }
        }.onAppear {
            fieldFocused = false
        }
    }
    
    @ViewBuilder
    func exerciseListView(_ exercises: [Exercise]) -> some View {
        VStack {
            HStack {
                HStack {
                    Image.magnifyingGlass
                    TextField(Strings.searchString.localized(),
                              text: $searchText)
                    .textFieldStyle(.plain)
                }.padding()
                    .roundEdges(lineColor: fieldFocused ? .purple : .gray)
                    .focused($fieldFocused)
                CustomPicker(selected: $exerciseCategory) {
                    HStack {
                        ForEach(ExerciseCategory.allCases) { option in
                            Text("\(option.rawValue) (\((exercises).count))")
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
                .background(Color.darkBackground)
            Divider().frame(height: 2)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(exercises, id: \.self) { exercise in
                        Button {
                            navigationModel.goToEditor(track.slug, exercise.slug)
                        } label: {
                            ExerciseGridView(exercise: exercise, solution: solutions[exercise.slug])
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

}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(track: PreviewData.shared.getTrack().first!, asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
    }
}

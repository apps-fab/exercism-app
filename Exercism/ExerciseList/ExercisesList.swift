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
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var searchText = ""
    var track: Track
    
    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]
    
    var body: some View {
        ScrollView {
            exerciseList()
        }.task {
            do {
                try await model.exercises(for: track)
            } catch {
                //show error
            }
        }.onChange(of: searchText) { newValue in
            model.filter(.SearchExercises(query: newValue))
        }
        .onChange(of: exerciseCategory) { newValue in
            model.toggleSelection(newValue)
        }
    }
    
    func exerciseList() -> some View {
        VStack() {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search by title", text: $searchText)
                        .textFieldStyle(.plain)
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(Color("darkBackground")))
                    .frame(minWidth: 400)
                CustomPicker(selected: $exerciseCategory) {
                    HStack {
                        ForEach(ExerciseCategory.allCases) { option in
                            Text("\(option.rawValue) (\(model.exercises.count))")
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
            Divider().frame(height: 2)
            LazyVGrid(columns: columns) {
                ForEach(model.exercises, id: \.self) { exercise in
                    Button {
                        coordinator.goToEditor(track.slug, exercise.slug)
                    } label: {
                        ExerciseGridView(exercise: exercise)
                    }.buttonStyle(.plain)
                }
            }
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        TracksListView()
    }
}

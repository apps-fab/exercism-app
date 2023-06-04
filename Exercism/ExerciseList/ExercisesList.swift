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
    let track: Track

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]

    var body: some View {
        AsyncResultView(source: AsyncModel(operation: { try await model.getExercises(track) })) { exercises in
            ScrollView {
                VStack {
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
                    Divider().frame(height: 2)
                    LazyVGrid(columns: columns) {
                        ForEach(exercises, id: \.self) { exercise in
                            Button {
                                coordinator.goToEditor(track.slug, exercise)
                            } label: {
                                ExerciseGridView(exercise: exercise)
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }.padding()
        }.onChange(of: searchText) { newValue in
//
        }.onChange(of: exerciseCategory) { newValue in
            //
        }
    }
}

//struct ExercisesList_Previews: PreviewProvider {
//    static var previews: some View {
//        ExercisesList(coordinator: AppCoordinator(), track: Tr)
//    }
//}

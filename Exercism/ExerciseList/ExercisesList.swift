//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI
import ExercismSwift

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case AllExercises
    case Completed
    case InProgress
    case Available
    case locked

    var id: Self {
        return self
    }
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
    @State private var showSubmitSolutionAlert = false


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
                        }
                            .padding()
                    }
                        .padding()
                    Divider().frame(height: 2)
                    LazyVGrid(columns: columns) {
                        ForEach(exercises, id: \.self) { exercise in
                            let solution = model.getSolution(for: exercise)
                            Button {
                                if (solution?.status == .iterated) {
                                    showSubmitSolutionAlert = true
                                } else {
                                    coordinator.goToEditor(track.slug, exercise)
                                }
                            } label: {
                                ExerciseGridItem(exercise: exercise, solution: solution)
                                    .sheet(isPresented: $showSubmitSolutionAlert) {
                                        SubmitSolutionContentView()
//                                        Alert(
//                                            title: Text("Publish your code and share your knowledge").font(.headline),
//                                            message: SubmitSolutionContentView(),
//                                            primaryButton: .default(Text("Publish"), action: { coordinator.goToEditor(track.slug, exercise) }),
//                                            secondaryButton: .default(Text("Continue to Iterate"), action: { showSubmitSolutionAlert = false; coordinator.goToEditor(track.slug, exercise) })
//                                        )
                                    }
                            }
                                .buttonStyle(.plain)
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
                            ExerciseGridItem(exercise: exercise, solution: getSolution(for: exercise))
                        }.buttonStyle(.plain)
                    }
                }.if(exercises.isEmpty) { _ in
                    EmptyStateView {
                        searchText = ""
                    }
                }
            }
                .padding()
        }
            .onChange(of: searchText) { newValue in
            }
            .onChange(of: exerciseCategory) { newValue in
            }
    }

    func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
}

struct SubmitSolutionContentView: View {
    @State private var shareSolution: Int = 0
    @State private var markComplete: Bool = false
    @State private var showSubOptions: Bool = false
    @State private var selectedSubOption: Int = 0
    @State private var selectedDropdownItem: Int = 0
    private let dropdownItems = [
        "Yes, I'd like to share my solution with the community.",
        "No, I just want to mark the exercise as complete."
    ]

    var body: some View {

        VStack(alignment: .leading) {
            Text("Publish your code and share your knowledge").font(.largeTitle)

            Text("By publishing your code, you'll help others learn from your work. \n You can choose which iterations you publish, add more iterations once it's published, and unpublish it at any time.").font(.title)

            List(dropdownItems, id: \.self, selection: $shareSolution) { item in
                Text(item).tag(dropdownItems.firstIndex(of: item))
            }
                .padding()

            if shareSolution == 0 {
                Divider()

                Toggle("All iterations", isOn: $showSubOptions)
                    .padding()

                if showSubOptions {
                    HStack {
                        Picker(selection: $selectedSubOption, label: Text("")) {
                            Text("All iterations").tag(0)
                            Text("Single iteration").tag(1)
                        }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()

                        if selectedSubOption == 0 {
                            Divider()

                            DropdownView(selectedItem: $selectedDropdownItem)
                                .padding()
                        }
                    }
                }
            }

            HStack {
                Button(action: {}) {
                    Text("Publish")
                        .foregroundColor(.white)
                }
                    .padding()
                    .frame(minWidth: 100, maxHeight: 40)
                    .roundEdges(backgroundColor: Color("darkBackground"), lineColor: .clear)
                Button(action: {}) {
                    Text("Continue to Iterate")
                        .foregroundColor(.white)
                }
                    .padding()
                    .frame(minWidth: 100, maxHeight: 40)
                    .roundEdges(backgroundColor: Color("darkBackground"), lineColor: .clear)
            }
        }
            .padding()
    }
}

struct DropdownView: View {
    @Binding var selectedItem: Int

    var body: some View {
        Picker(selection: $selectedItem, label: Text("")) {
            Text("Item 1").tag(0)
            Text("Item 2").tag(1)
        }
            .pickerStyle(MenuPickerStyle())
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(track: PreviewData.shared.getTrack().first!, asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
    }
}
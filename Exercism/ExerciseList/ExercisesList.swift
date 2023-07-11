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
    @State private var currentSolutionIteration: Iteration


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
                        let solution = model.getSolution(for: exercise)
                        Button {
                            if (solution?.status == .iterated) {
                                showSubmitSolutionAlert = true
                            } else {
                                coordinator.goToEditor(track.slug, exercise.slug)
                            }
                        } label: {
                            ExerciseGridItem(exercise: exercise, solution: solution)
                                .sheet(isPresented: $showSubmitSolutionAlert) {
                                    SubmitSolutionContentView(isPresented: $showSubmitSolutionAlert).task {
                                         currentSolutionIteration = try! await model.getIteration(for: solution!.uuid)
                                    print("current \(currentSolutionIteration)")
                                }
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

enum ShareOptions: String, CaseIterable {
    case Complete = "No, I just want to mark the exercise as complete."
    case Share = "Yes I'd like to share my solution with the community"

    enum Iterations: String, CaseIterable {
        case All = "All iterations"
        case Single = "Single iteration"
    }
}

struct SubmitSolutionContentView: View {
    @State private var shareOption = ShareOptions.Share
    @State private var shareIterationsOptions = ShareOptions.Iterations.Single
    @State private var selectedIteration = 1
    @State private var numberOfIterations = 4
    @Binding var isPresented: Bool

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Image(systemName: "terminal")
                    .frame(width: 50, height: 50)

                Text("Publish your code and share your knowledge")
                    .multilineTextAlignment(.leading)
                    .font(.largeTitle)
                    .padding()
                Text("By publishing your code, you'll help others learn from your work. You can choose which iterations you publish, add more iterations once it's published, and unpublish it at any time.")
                    .multilineTextAlignment(.leading)
                    .padding()
                listItems.padding()
                HStack {
                    Button("Confirm") {
                        print("confirm thing")
                    }.frame(width: 100, height: 30)
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .buttonStyle(.plain)
                    Button("Close") {
                        isPresented = false
                    }.frame(width: 100, height: 30)
                        .buttonStyle(.plain)
                        .roundEdges(backgroundColor: Color.gray)
                }
            }
            Image("publishMan").frame(width: 300, height: 300)
        }.padding()
            .frame(width: 800, height: 400)
    }

    var listItems: some View {
        VStack {
            Picker("", selection: $shareOption) {
                ForEach(ShareOptions.allCases, id: \.self) { option in
                    Text(option.rawValue).bold()
                }
            }.pickerStyle(.radioGroup)

            if shareOption == .Share {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Picker("", selection: $shareIterationsOptions) {
                            ForEach(ShareOptions.Iterations.allCases, id: \.self) { iteration in
                                Text(iteration.rawValue)
                            }
                        }.pickerStyle(.radioGroup)
                            .horizontalRadioGroupLayout()
                        Menu {
                            ForEach(1...numberOfIterations, id: \.self) { index in
                                Text("Iteration \(index)")
                            }
                        } label: {
                            Text("Iteration \(selectedIteration)").roundEdges()
                        }.opacity(shareIterationsOptions == .All ? 0 : 1)
                            .frame(width: 100)
                    }
                }.padding()

            }
        }
    }
}

struct SubmitSolutionContentView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitSolutionContentView(isPresented: .constant(true))
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(track: PreviewData.shared.getTrack().first!, asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
    }
}

//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI
import ExercismSwift

extension Solution: Identifiable {
    public var id: String { self.uuid }
}

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case AllExercises = "All Exercises"
    case Completed
    case InProgress = "In Progress"
    case Available
    case Locked
    
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
        
    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]
    
   
    var body: some View {
        AsyncResultView(source: asyncModel) { exercises in
            exerciseListView(exercises)
        }
        .onChange(of: searchText) { newValue in
            asyncModel.filterOperations  = { TrackModel.shared.filterExercises(newValue) }
        }
        .onChange(of: exerciseCategory) { newValue in
            //implement this
        }
        .task {
            do {
                let solutionsList = try await TrackModel.shared.getSolutions(track)

                self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
            } catch {
                print("Unable to get the solutions", error)
            }
        }
        .onAppear {
            fieldFocused = false
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(track.slug.uppercased())
                    .font(.headline)
            }

            ToolbarItem(placement: .navigation) {
                Button {
                    navigationModel.goBack()
                } label: {
                    Label("", systemImage: "chevron.backward")
                }
            }
        }
    }
    
    @ViewBuilder
    func exerciseListView(_ exercises: [Exercise]) -> some View {
        let groupedExercises = groupExercises(exercises)
        let filteredExercises = groupedExercises[exerciseCategory] ?? exercises
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
                            Text("\(option.rawValue) (\((groupedExercises[option] ?? exercises).count))")
                                .padding()
                                .frame(minWidth: 140, maxHeight: 40)
                                .roundEdges(backgroundColor: option == exerciseCategory ? Color.gray : .clear, lineColor: .clear)
                                .onTapGesture {
                                    exerciseCategory = option
                                }
                        }
                    }
                }.padding()
            }
            .padding()
            .background(Color.darkBackground)
            
            Divider().frame(height: 2)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(filteredExercises, id: \.self) { exercise in
                        let solution = getSolution(for: exercise)                  
                        
                        Button {
                            navigationModel.goToEditor(track.slug, exercise, solution: solution)
                        } label: {
                            ExerciseGridView(exercise: exercise, solution: solution)
                        }.buttonStyle(.plain)
                    }
                }.if(filteredExercises.isEmpty) { _ in
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
    
    /// Group exercises by category
    /// - Parameter exercises:
    /// - Returns: [ExerciseCategory: [Exercise]]
    func groupExercises(_ exercises: [Exercise]) -> [ExerciseCategory: [Exercise]] {
        var groupedExercises = [ExerciseCategory: [Exercise]]()
        for category in ExerciseCategory.allCases {
            groupedExercises[category] = filterExercises(by: category, exercises: exercises)
        }
        return groupedExercises
    }
    
    
    func filterExercises(by category: ExerciseCategory, exercises: [Exercise]) -> [Exercise] {
        switch category {
        case .AllExercises:
            return exercises
        case .Completed:
            return exercises.filter { getSolution(for: $0)?.status == .completed || getSolution(for: $0)?.status == .published }
        case .InProgress:
            return exercises.filter { getSolution(for: $0)?.status == .started || getSolution(for: $0)?.status == .iterated }
        case .Available:
            return exercises.filter { $0.isUnlocked && getSolution(for: $0) == nil }
        case .Locked:
            return exercises.filter { !$0.isUnlocked }
        }
    }
}

struct ExercisesList_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesList(track: PreviewData.shared.getTrack().first!, asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
    }
}

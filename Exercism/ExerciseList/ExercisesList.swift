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
    @State var track: Track
    @State var asyncModel: AsyncModel<[Exercise]>
    
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var searchText = ""
    @State private var solutions = [String: Solution]()
    @FocusState private var fieldFocused: Bool
    @State private var alertItem = AlertItem()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        AsyncResultView(source: asyncModel) { exercises in
            exerciseListView(exercises)
        }
        .onChange(of: searchText) { oldValue, newValue in
            asyncModel.filterOperations  = { TrackModel.shared.filterExercises(newValue) }
        }
        .task {
            do {
                let solutionsList = try await TrackModel.shared.getSolutions(track)
                self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
            } catch {
                alertItem = AlertItem(title: "Error",  message: error.localizedDescription)
            }
        }
        .onAppear {
            fieldFocused = false
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(track.slug)
                    .textCase(.uppercase)
                    .font(.headline)
            }
        }
        .alert(alertItem.title, isPresented: $alertItem.isPresented) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(alertItem.message)
        }
    }
    
    @ViewBuilder
    private func exerciseListView(_ exercises: [Exercise]) -> some View {
        let groupedExercises = groupExercises(exercises)
        let filteredExercises = groupedExercises[exerciseCategory] ?? exercises
        
        VStack(spacing: 0) {
            HStack {
                searchField
                    .frame(minWidth: 200)
                
                CustomPicker(selection: $exerciseCategory, items: ExerciseCategory.allCases) { option in
                    Text("\(option.rawValue) (\((groupedExercises[option] ?? exercises).count))")
                    
                }
            }
            .padding()
            .background(Color.appDarkBackground)
            
            Divider()
            
            ScrollView {
                if filteredExercises.isEmpty {
                    EmptyStateView {
                        searchText = ""
                    }
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(filteredExercises, id: \.self) { exercise in
                            let solution = getSolution(for: exercise)
                            
                            Button {
                                navigationModel.goToEditor(track.slug, exercise, solution: solution)
                            } label: {
                                ExerciseGridView(exercise: exercise, solution: solution)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
    
    private var searchField: some View {
        HStack(spacing: 12) {
            Image.magnifyingGlass
                .imageScale(.large)
            
            TextField(Strings.searchString.localized(),
                      text: $searchText)
            .textFieldStyle(.plain)
        }
        .padding(8)
        .roundEdges(
            lineColor: fieldFocused ? .purple : .gray,
            cornerRadius: 8
        )
        .focused($fieldFocused)
    }
    
    
    private func getSolution(for exercise: Exercise) -> Solution? {
        solutions[exercise.slug]
    }
    
    /// Group exercises by category
    /// - Parameter exercises:
    /// - Returns: [ExerciseCategory: [Exercise]]
    private func groupExercises(_ exercises: [Exercise]) -> [ExerciseCategory: [Exercise]] {
        var groupedExercises = [ExerciseCategory: [Exercise]]()
        for category in ExerciseCategory.allCases {
            groupedExercises[category] = filterExercises(by: category, exercises: exercises)
        }
        return groupedExercises
    }
    
    private func filterExercises(by category: ExerciseCategory, exercises: [Exercise]) -> [Exercise] {
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

#Preview {
    ExercisesList(track: PreviewData.shared.getTracks()[0],
                  asyncModel: AsyncModel(operation: { PreviewData.shared.getExercises()}))
        .frame(width: 1000, height: 800)
        .previewLayout(.device)
        .preferredColorScheme(.light)
}

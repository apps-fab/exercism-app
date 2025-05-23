//
//  ExercisesList.swift
//  Exercism
//
//  Created by Angie Mugo on 21/11/2022.
//

import SwiftUI
import ExercismSwift

extension Solution: @retroactive Identifiable {
    public var id: String { self.uuid }
}

enum ExerciseCategory: String, CaseIterable, Identifiable {
    case allExercises = "All Exercises"
    case completed
    case inProgress = "In Progress"

    case available
    case locked

    var id: Self { return self }
}

struct ExercisesList: View {
    @FocusState private var fieldFocused: Bool
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: ExerciseListViewModel
    @State private var exerciseCategory: ExerciseCategory = .allExercises
    @State private var searchText = ""
    @State private var solutions = [String: Solution]()
    @State private var alertItem = AlertItem()
    let track: Track

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(track: Track) {
        self.track = track
        _viewModel = StateObject(wrappedValue: ExerciseListViewModel(track: track))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .failure(let error):
                Text(error.localizedDescription)
            case .success(let exercises):
                exerciseListView(exercises)
            case .idle:
                EmptyView()
            }
        }.task {
            await getExercises()
        }.onChange(of: searchText) { newValue in
            viewModel.filterExercises(newValue)
        }.onAppear {
            fieldFocused = false
        }.toolbar {
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

    private func getExercises() async {
        do {
            let solutionsList = try await viewModel.getSolutions(track)
            self.solutions = Dictionary(uniqueKeysWithValues: solutionsList.map({($0.exercise.slug, $0)}))
        } catch {
            alertItem = AlertItem(title: "Error", message: error.localizedDescription)
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
                                navigationModel.goToEditor(track.slug, exercise)
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
        }.padding(8)
            .roundEdges(
                lineColor: fieldFocused ? .appAccent : .gray,
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
        case .allExercises:
            return exercises
        case .completed:
            return exercises.filter {
                getSolution(for: $0)?.status == .completed || getSolution(for: $0)?.status == .published
            }
        case .inProgress:
            return exercises.filter {
                getSolution(for: $0)?.status == .started || getSolution(for: $0)?.status == .iterated
            }
        case .available:
            return exercises.filter { $0.isUnlocked && getSolution(for: $0) == nil }
        case .locked:
            return exercises.filter { !$0.isUnlocked }
        }
    }
}

#Preview {
    ExercisesList(track: PreviewData.shared.getTracks()[0])
        .frame(width: 1000, height: 800)
        .preferredColorScheme(.light)
}

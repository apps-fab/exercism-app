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

    var imageName: String {
        switch self {
        case .completed:
            return "checkmark.circle.fill"
        case .inProgress:
            return "circle.fill"
        case .available:
            return "lock.open"
        case .locked:
            return "lock"
        case .allExercises:
            return ""
        }
    }
}

struct ExercisesList: View {
    @FocusState private var fieldFocused: Bool
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: ExerciseListViewModel
    @State private var alertItem = AlertItem()

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(track: Track) {
        _viewModel = StateObject(wrappedValue: ExerciseListViewModel(track))
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            case .failure(let error):
                Text(error.description)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            case .success(let exercises):
                exerciseListView(exercises)
            case .idle:
                EmptyView()
            }
        }.onAppear {
            fieldFocused = false
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.track.title)
                    .textCase(.uppercase)
                    .font(.headline)
            }
        }
        .task {
            await viewModel.loadData()
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
        let groupedExercises = viewModel.filteredGroupedExercises

        VStack(spacing: 0) {
            HStack {
                searchField
                    .frame(minWidth: 200)

                CustomPicker(selection: $viewModel.selectedCategory, items: ExerciseCategory.allCases) { option in
                    Label {
                        Text("\(option.rawValue.capitalized) (\((groupedExercises[option] ?? exercises).count))")
                    } icon: {
                        Image(systemName: option.imageName)
                    }
                }
            }
            .padding()
            .background(Color.appDarkBackground)

            Divider()

            ScrollView {
                if exercises.isEmpty {
                    EmptyStateView {
                        viewModel.searchText = ""
                        viewModel.selectedCategory = .allExercises
                    }
                } else {
                    LazyVGrid(columns: columns) {
                        ForEach(exercises, id: \.self) { exercise in
                            let solution = viewModel.getSolution(for: exercise)

                            Button {
                                navigationModel.goToEditor(viewModel.track.slug,
                                                           exercise)
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
                      text: $viewModel.searchText)
            .textFieldStyle(.plain)
        }.padding(8)
            .roundEdges(
                lineColor: fieldFocused ? .appAccent : .gray,
                cornerRadius: 8
            )
            .focused($fieldFocused)
    }
}

 #Preview {
    ExercisesList(track: PreviewData.shared.getTracks()[0])
        .frame(width: 1000, height: 800)
 }

//
//  ExerciseEditorWindowView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseEditorWindowView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: ExerciseViewModel
    @Environment(\.streakManager) var streak
    @Namespace private var flameNamespace
    @State private var scale: CGFloat = 0.5
    @State private var animateToToolbar = false
    @State private var fadeOut = true

    init(_ track: String, _ exercise: String) {
        let viewModel = ExerciseViewModel(track, exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let result):
                NavigationSplitView {
                    ExerciseRightSidebarView()
                        .environmentObject(result.1)
                        .accessibilityLabel("Side Bar Window")
                } detail: {
                    CustomTabView(selectedItem: $viewModel.selectedFile) {
                        ForEach(result.0) { file in
                            ZStack(alignment: .center) {
                                ExerciseEditorView()
                                    .environmentObject(result.1)
                                    .tabItem(for: file)
                                    .accessibilityLabel("Editor Window")
                            }
                        }
                    }
                }.environmentObject(viewModel)
                    .accessibilityLabel("Main Editor Window")
            case .failure(let error):
                Text(error.description)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            }
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                    StreakView()
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.revertToStart()
                    }
                } label: {
                    Image.revert
                }.tooltip(Strings.revertExercise.localized())
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.submitSolution()
                    }
                } label: {
                    Label {
                        Text(Strings.submit.localized())
                    } icon: {
                        Image.paperplaneCircle
                    }
                    .labelStyle(.titleAndIcon)
                    .fixedSize()
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    Task {
                        await viewModel.runTests()
                    }
                } label: {
                    Label {
                        Text(Strings.runTests.localized())
                    } icon: {
                        Image.playCircle
                    }
                    .labelStyle(.titleAndIcon)
                    .fixedSize()
                }
            }
        }.navigationTitle(viewModel.title)
            .task {
                await viewModel.getDocument()
                streak.updateStreak()
            }
    }
}

#Preview {
    ExerciseEditorWindowView("Swift", "hello-world")
        .frame(width: 800, height: 400)
}

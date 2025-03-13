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
    @State private var showSubmissionTooltip = false

    init(_ track: String, _ exercise: String, _ solution: Solution? = nil) {
        _viewModel = StateObject(wrappedValue: ExerciseViewModel(track, exercise, solution))
    }

    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let document):
                NavigationSplitView {
                    ExerciseRightSidebarView()
                } detail: {
                    CustomTabView(selectedItem: $viewModel.selectedFile) {
                        ForEach(document) { file in
                            ExerciseEditorView()
                                .tabItem(for: file)
                        }
                    }
                }.environmentObject(viewModel)
                    .onAppear {
                        print("ExerciseEditorWindowView appeared")
                    }
                    .onDisappear {
                        print("ExerciseEditorWindowView disappeared")
                    }
            case .failure(let error):
                Text(error.description)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarItem {
                Spacer()
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.runTest()
                } label: {
                    Label(Strings.runTests.localized(),
                          systemImage: "play.circle")
                    .labelStyle(.titleAndIcon)
                    .fixedSize()
                }.disabled(!viewModel.canRunTests)
                    .if(!viewModel.canSubmitSolution) { button in
                        button.tooltip("cannot run tests right now")
                    }
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.submitSolution()
                } label: {
                    Label(Strings.submit.localized(),
                          systemImage: "paperplane.circle")
                    .labelStyle(.titleAndIcon)
                    .fixedSize()
                }
                .disabled(!viewModel.canSubmitSolution)
                .if(!viewModel.canSubmitSolution) { button in
                    button.tooltip(Strings.runTestsError.localized())
                }
            }

        }
        .navigationTitle(viewModel.title)
        .sheet(item: $viewModel.solutionToSubmit) { _ in
            SubmitSolutionContentView()
                .environmentObject(viewModel)
        }
    }
}

// #Preview {
//    ExerciseEditorWindowView(track: "Swift",
//                             exercise: "hello world",
//                             solution: PreviewData.shared.getSolutions()[0])
// }

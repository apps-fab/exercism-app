//
//  ExerciseEditorWindowView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseEditorWindowView: View {
    @StateObject var viewModel = ExerciseViewModel.shared
    @State private var showSubmissionTooltip = false
    
    let solution: Solution?
    var canMarkAsComplete: Bool {
        solution?.status == .iterated
    }

    @State private var currentSolutionIterations: [Iteration] = []

    @State var asyncModel: AsyncModel<[ExerciseFile]>
    @EnvironmentObject private var navigationModel: NavigationModel

    var body: some View {
        AsyncResultView(source: asyncModel) { docs in
            NavigationSplitView {
                ExerciseRightSidebarView(canMarkAsComplete: canMarkAsComplete,
                                         onMarkAsComplete: {
                    if (canMarkAsComplete) {
                        viewModel.setSolutionToSubmit(solution)
                    }
                })
            } detail: {
                CustomTabView(selectedItem: $viewModel.selectedFile) {
                    ForEach(docs) { file in
                        ExerciseEditorView().tabItem(for: file)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        print("Item", docs)
                        //                        viewModel.runTest()
                    }) {
                        Label(Strings.runTests.localized(),
                              systemImage: "play.circle")
                        .labelStyle(.titleAndIcon)
                        .fixedSize()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.submitSolution()
                    }) {
                        Label(Strings.submit.localized(),
                              systemImage: "paperplane.circle")
                        .labelStyle(.titleAndIcon)
                        .fixedSize()
                    }
                    .disabled(!viewModel.canSubmitSolution)
                    .onTapGesture {
                        if !viewModel.canSubmitSolution {
                            showSubmissionTooltip = true
                            print("showSubmissionTooltip: \(showSubmissionTooltip)")
                        }
                    }
                    .help("You need to run the tests before submitting.")
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
        .navigationTitle(viewModel.title)
        .sheet(
            item: $viewModel.solutionToSubmit,
            onDismiss: {
                viewModel.setSolutionToSubmit(nil)
            }
        ) { solution in
            SubmitSolutionContentView(iterations: currentSolutionIterations)
        }
        
        .task {
            guard let solution else { return }
            do {
                currentSolutionIterations = try await TrackModel.shared.getIterations(for: solution.uuid)
                print(currentSolutionIterations)
            } catch {
                print("Error getting iterations:", error)
            }
        }
    }
}

struct ExerciseEditorWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditorWindowView(solution: nil, asyncModel: AsyncModel(operation: {
            PreviewData.shared.getExerciseFile()
        }))
//        ExerciseEditorWindowView(exercise: "Rust", track: "Hello-world").environmentObject(SettingData())
    }
}

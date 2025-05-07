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

    init(_ track: String, _ exercise: String) {
        let viewModel = ExerciseViewModel(track, exercise)
        _viewModel = StateObject(wrappedValue: viewModel)
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
                        .environmentObject(viewModel)
                } detail: {
                    CustomTabView(selectedItem: $viewModel.selectedFile) {
                        ForEach(document) { file in
                            ExerciseEditorView()
                                .tabItem(for: file)
                        }
                    }
                }.environmentObject(viewModel)
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

            // hide for now
            //            ToolbarItem(placement: .primaryAction) {
            //                Button {
            //                    viewModel.revertToStart()
            //                } label: {
            //                    Image.revert
            //                }.tooltip(Strings.revertExercise.localized())
            //            }

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
                }.disabled(!viewModel.canRunTests)
                    .if(viewModel.canRunTests) { button in
                        button.tooltip(Strings.runTestsTitle.localized())
                    }
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
                .disabled(!viewModel.canSubmit)
                .if(!viewModel.canSubmit) { button in
                    button.tooltip(Strings.runTestsError.localized())
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}

#Preview {
    ExerciseEditorWindowView("Swift",
                             "hello world")
}

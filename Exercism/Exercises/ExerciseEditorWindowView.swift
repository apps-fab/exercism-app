//
//  ExerciseEditorWindowView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseEditorWindowView: View {
    @StateObject var viewModel = ExerciseViewModel()
    @State private var showSubmissionTooltip = false

    let exercise: String
    let track: String

    var body: some View {
        NavigationSplitView {
            ExerciseRightSidebarView()
        } detail: {
            CustomTabView(selectedItem: $viewModel.selectedFile) {
                ForEach(viewModel.tabbableSolutionFiles) { file in
                    ExerciseEditorView().tabItem(for: file)
                }
            }
            .toolbar {
                ToolbarItem(content: { Spacer() })
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.runTest()
                    }, label: { // 1
                        HStack {
                            Image.playCircle
                            Text(Strings.runTests.localized())
                        }
                    })
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.submitSolution()
                    }, label: { // 1
                        HStack {
                            Image.paperplaneCircle
                            Text(Strings.submit.localized())
                        }
                    })
                    .disabled(!viewModel.canSubmitSolution)
                    .onTapGesture {
                        if !viewModel.canSubmitSolution {
                            showSubmissionTooltip = true
                            print("showSubmissionTooltip: \($0)")
                        }
                    }
                    .if(showSubmissionTooltip) { view in
                        view
                    }.help("You need to run the tests before submitting.")
                }
            }
        }.onAppear {
            viewModel.getDocument(track: track, exercise: exercise)
        }
        .environmentObject(viewModel)
        .navigationTitle(Text(viewModel.getTitle()))
    }
}

struct ExerciseEditorWindowView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditorWindowView(exercise: "Rust", track: "Hello-world").environmentObject(SettingData())
    }
}

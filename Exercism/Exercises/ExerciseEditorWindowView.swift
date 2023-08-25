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
    @State var asyncModel: AsyncModel<[ExerciseFile]>

    var body: some View {
        AsyncResultView(source: asyncModel) { docs in
            NavigationSplitView {
                ExerciseRightSidebarView()
            } detail: {
                CustomTabView(selectedItem: $viewModel.selectedFile) {
                    ForEach(docs) { file in
                        ExerciseEditorView().tabItem(for: file)
                    }
                }
            }.toolbar {
                ToolbarItem {
                    Spacer()
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        viewModel.runTest()
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
            }
        }.navigationTitle(viewModel.title)
    }

}

//struct ExerciseEditorWindowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseEditorWindowView(exercise: "Rust", track: "Hello-world").environmentObject(SettingData())
//    }
//}

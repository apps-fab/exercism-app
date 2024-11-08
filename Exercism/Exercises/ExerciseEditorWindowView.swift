//
//  ExerciseEditorWindowView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import ExercismSwift

extension ExercismClientError {
    var description: String {
        switch self {
        case .genericError(let underlyingError):
            return "An error occurred: \(underlyingError.localizedDescription)"
        case .apiError(let code, let type, let message):
            return "API Error - Code: \(code.rawValue), Type: \(type), Message: \(message)"
        case .bodyEncodingError(let underlyingError):
            return "Error encoding request body: \(underlyingError.localizedDescription)"
        case .decodingError(let underlyingError):
            return "Error decoding response: \(underlyingError.localizedDescription)"
        case .unsupportedResponseError:
            return "Received an unsupported response"
        case .builderError(let message):
            return "Builder Error: \(message)"
        }
    }
}

struct ExerciseEditorWindowView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var viewModel: ExerciseViewModel

    @State private var showSubmissionTooltip = false
    @State var asyncModel: AsyncModel<[ExerciseFile]>

    let solution: Solution?
    var canMarkAsComplete: Bool {
        solution?.status == .iterated || solution?.status == .published || solution?.status == .completed
    }

    var body: some View {
        AsyncResultView(source: asyncModel) { docs in
            NavigationSplitView {
                ExerciseRightSidebarView().environmentObject(viewModel)
            } detail: {
                CustomTabView(selectedItem: $viewModel.selectedFile) {
                    ForEach(docs) { file in
                        ExerciseEditorView()
                        .tabItem(for: file)
                    }.onChange(of: viewModel.selectedCode) { code in
                        viewModel.updateCode(code)
                    }
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
                    .onTapGesture {
                        if !viewModel.canSubmitSolution {
                            showSubmissionTooltip = true
                        }
                    }
                    .help(Strings.runTestsError.localized())
                }
            }
        }
        .navigationTitle(viewModel.title)
        .sheet(item: $viewModel.solutionToSubmit) { _ in
            SubmitSolutionContentView()
        }
        .task {
            guard let solution else { return }
            await viewModel.getIterations(for: solution)
        }
    }
}

#Preview {
        ExerciseEditorWindowView(asyncModel: AsyncModel(operation: {
            PreviewData.shared.getExerciseFile()
        }), solution: PreviewData.shared.getSolutions()[0])
}

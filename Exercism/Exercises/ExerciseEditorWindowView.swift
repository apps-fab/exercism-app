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
    @StateObject private var viewModel: ExerciseViewModel
    @AppStorage("shouldWriteToFile") private var shouldWriteToFile = false
    @State private var showSubmissionTooltip = false
    let solution: Solution?
    var canMarkAsComplete: Bool {
        solution?.status == .iterated || solution?.status == .published || solution?.status == .completed
    }

    init( track: String, exercise: String, solution: Solution?) {
        self.solution = solution
        _viewModel = StateObject(wrappedValue: ExerciseViewModel(track, exercise))
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
                                ExerciseRightSidebarView(onMarkAsComplete: canMarkAsComplete ? { viewModel.setSolutionToSubmit(solution)} : nil).environmentObject(viewModel)
                            } detail: {
                                CustomTabView(selectedItem: $viewModel.selectedFile) {
                                    ForEach(viewModel.documents) { file in
                                        ExerciseEditorView()
                                            .tabItem(for: file)
                                            .environmentObject(viewModel)
                                    }
                                }
                            }
            case .failure(let exercismClientError):
                Text(exercismClientError.localizedDescription)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }.onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
            viewModel.updateFile()
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
    ExerciseEditorWindowView(track: "Swift", exercise: "hello world", solution: PreviewData.shared.getSolutions()[0])
}

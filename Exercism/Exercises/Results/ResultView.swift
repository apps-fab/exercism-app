//
//  ResultView.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI
import ExercismSwift
import Splash

struct ResultView: View {
    let language: String
    let theme: Splash.Theme
    @EnvironmentObject private var viewModel: EditorActionsViewModel

    public var body: some View {
        if case let .testInProgress(progress) = viewModel.state {
            TestRunProgress(totalSecs: progress)
        } else if case let .testRunSuccess(_, testRun) = viewModel.state {
            TestRunResultView(
                testRun: testRun,
                language: language,
                theme: theme
            )
        } else if case _ = viewModel.state {
            if let testRun = viewModel.testRun {
                TestRunResultView(
                    testRun: testRun,
                    language: language,
                    theme: theme
                )
            } else {
                NoTestRun()
            }
        }
    }
}

#Preview {
    let testRun = PreviewData.shared.testRun()
    let submission = PreviewData.shared.runTest()

    let viewModel = EditorActionsViewModel(solutionUUID: "", exerciseItem: nil, iterations: [])
    viewModel.state = .testRunSuccess(submission.links, testRun)

    return ResultView(
        language: "Swift",
        theme: Theme.wwdc18(withFont: Font(size: 16.0))
    )
    .environmentObject(viewModel)
}

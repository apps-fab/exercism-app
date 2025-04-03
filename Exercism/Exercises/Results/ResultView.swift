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
    @EnvironmentObject private var viewModel: ExerciseViewModel

    public var body: some View {
        if let averageTestDuration = viewModel.averageTestDuration {
            TestRunProgress(totalSecs: averageTestDuration)
        } else {
            if let testRun = viewModel.testRun {
                TestRunResultView(
                    testRun: testRun,
                    language: language,
                    theme: theme,
                    onSubmitTest: {
                        Task {
                            await viewModel.submitSolution()
                        }
                    }
                )
            } else {
                NoTestRun()
            }
        }
    }
}

#Preview {
    ResultView(language: "Swift", theme: Theme.wwdc18(withFont: Font(size: 16.0)))
}

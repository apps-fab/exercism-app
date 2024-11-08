//
//  ResultView.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI
import ExercismSwift
import Splash

enum ResultViewState {
    case inProgress(Double)
    case testsRun(TestRun)
    case noTestsRun
}

struct ResultView: View {
    let state: ResultViewState
    let language: String
    let theme: Splash.Theme

    public var body: some View {
        switch state {
        case .inProgress(let duration):
            TestRunProgress(totalSecs: duration)
        case .testsRun(let testRun):
            TestRunResultView(testRun: testRun, language: language, theme: theme) {
                print("implement submit solution")
            }
        case .noTestsRun:
            NoTestRun()
        }
    }
}

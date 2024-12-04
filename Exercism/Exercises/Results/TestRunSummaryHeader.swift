//
//  TestRunSummaryHeader.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//

import SwiftUI
import ExercismSwift

struct TestRunSummaryHeader: View {
    var testRun: TestRun
    var headerText = ""
    var color = SwiftUI.Color.green

    init(testRun: TestRun) {
        self.testRun = testRun

        switch testRun.status {
        case .fail:
            if testRun.hasTasks() {
                let taskRun = testRun.tasks.count - testRun.numFailedTasks()
                headerText = String(format: Strings.taskCompleted.localized(), taskRun, testRun.tasks.count)
            } else {
                if testRun.version == 2 || testRun.version == 3 {
                    // TODO: - (@Kirk - 5/02/23: Convert this to stringdict for proper localisation)
                    let numFailedTests = self.testRun.numFailedTest()
                    let failureWord = numFailedTests == 1 ? "failure" : "failures"
                    headerText = "\(String(describing: numFailedTests)) test \(failureWord)"
                } else {
                    headerText = Strings.testFailed.localized()
                }
            }
        case .pass:
            headerText = Strings.taskPass.localized()
        case .error, .ops_error:
            headerText = Strings.errorOccurred.localized()
        case .timeout:
            headerText = Strings.testsTimedOut.localized()
        default:
            print("do nothing")
        }
    }

    var body: some View {
        Label {
            Text(headerText)
        } icon: {
            Image.circleFill
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(testRun.status == .pass ? .green : .red.opacity(0.2))
        .foregroundColor(testRun.status == .pass ? .green : .red)
        .bold()
        .textCase(.uppercase)
        .multilineTextAlignment(.center)
    }
}

#Preview("Test Run Summary") {
    TestRunSummaryHeader(testRun: PreviewData.shared.testRun())
}

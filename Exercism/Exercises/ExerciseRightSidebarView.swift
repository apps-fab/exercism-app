//
//  ExerciseRightSidebarView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 29/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseRightSidebarView: View {
    @EnvironmentObject var exerciseObject: ExerciseViewModel
    var instruction: String? {
        exerciseObject.instruction
    }

    var body: some View {
        TabView {
            if let instruction = instruction {

                VStack {
                    Text(instruction)
                }
                    .tabItem {
                        TabLabel(imageName: "checklist", label: "Instructions")
                    }
            }
            VStack(alignment: HorizontalAlignment.leading) {
                if let averageTestDuration = exerciseObject.averageTestDuration {
                    TestRunProgress(totalSecs: averageTestDuration)
                } else {
                    if let testRun = exerciseObject.testRun {
                        if case let .pass = testRun.status {
                            TestPassed()
                        } else {
                            TestRunSummaryHeader(testRun: testRun)
                            TestGroupedByTaskList(testRun: testRun)
                        }
                    } else {
                        NoTestRun()
                    }
                }
            }
                .tabItem {
                    TabLabel(imageName: "text.badge.checkmark", label: "Results")
                }
        }
    }

    struct TabLabel: View {
        let imageName: String
        let label: String

        var body: some View {
            HStack {
                Image(systemName: imageName)
                Text(label)
            }
        }
    }

    struct NoTestRun: View {
        var body: some View {
            VStack {
                Image(systemName: "doc.badge.gearshape")
                Text("Run tests to check your code")
                Text("We'll run your code against tests to check whether it works, then give you the results here.")

            }
        }
    }

    struct TestRunProgress: View {
        let totalSecs: Double
        @State private var progress = 0.0
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
            VStack {
                ProgressView("Running tests...", value: progress, total: 100)
                    .onReceive(timer) { _ in
                        if progress < 100 {
                            progress += (100.0 / (totalSecs * 10.0))
                        }
                    }
                Text("Estimated running time ~ \(totalSecs)s")
            }
        }
    }

    struct TestPassed: View {
        var body: some View {
            VStack {
                Text("Sweet. Looks like you’ve solved the exercise!")
                Text("""
                      Good job! You can continue to improve your code or, if you're\n
                     done, submit an iteration to get automated feedback and\n
                     optionally request mentoring.
                     """)
                Button(action: {
                    print("submit")
                }, label: { // 1
                    Label("Submit", systemImage: "play")
                })
            }
        }
    }

    struct TestRunSummaryHeader: View {
        let testRun: TestRun
        var headerText = ""

        init(testRun: TestRun) {
            self.testRun = testRun

            switch testRun.status {
            case .fail:
                if (testRun.hasTasks()) {
                    headerText = "\(testRun.tasks.count - testRun.numFailedTasks()) / \(testRun.tasks.count) Tasks Completed"
                } else {
                    if (testRun.version == 2 || testRun.version == 3) {
                        // @Todo (Kirk - 5/02/23: Convert this to stringdict for proper localisation)
                        headerText = "\(String(describing: self.testRun.numFailedTest())) test \(testRun.numFailedTest() == 1 ? "failure" : "failures")"
                    } else {
                        headerText = "Tests failed"
                    }
                }
            case .pass:
                headerText = "All tasks passed"
            case .error, .ops_error:
                headerText = "An error occurred"
            case .timeout:
                headerText = "Your tests timed out"
            default:
                print("do nothing")
            }
        }

        var body: some View {
            Text(headerText)
        }
    }

    struct TestGroupedByTaskList: View {
        let testRun: TestRun
        var body: some View {
            let testGroup = testRun.testGroupedByTaskList()
            List(testGroup, children: \.tests) { group in
                if let task = group.task {
                    HStack {
                        Text("Task \(String(describing: task.id))")
                        Text(task.title)
                    }
                }
                if let test = group.test {
                    CollapsibleTest(test: test, testId: test.index ?? group.testId!).frame(width: 300.0)
                }
            }
        }
    }

    struct CollapsibleTest: View {
        let test: Test
        let testId: Int
        @State private var collapsed: Bool = true

        func statusLabel(status: TestStatus) -> String {
            var label = ""
            switch status {
            case .pass:
                label = "Passed"
                break
            default:
                label = "Failed"
            }

            return label
        }

        func messageLabel(status: TestStatus) -> String {
            var label = ""
            switch status {
            case .fail:
                label = "Test Failure"
                break
            case .error:
                label = "Test Error"
            case .pass:
                label = ""
            }

            return label
        }

        @State var showContent: Bool = true


        var body: some View {
            DisclosureGroup(
                isExpanded: $showContent,
                content: {
                    VStack {
                        if let testCode = test.testCode, !testCode.isEmpty {
                            Text("Code Run")
                            Text(testCode)
                        }

                        if let messageHtml = test.messageHtml, !messageHtml.isEmpty {
                            Text(messageLabel(status: test.status))
                            Text(messageHtml)
                        }

                        if let outputHtml = test.outputHtml, !outputHtml.isEmpty {
                            Text("Your Output")
                            Text(outputHtml)
                        }
                    }
                    .frame(width: 300.0)
                },

                label: {
                    HStack {
                        Text(statusLabel(status: test.status))
                        VStack {
                            Text("Test \(String(describing: testId))")
                            Text(test.name)
                        }
                    }
                        .padding(.bottom, 1)
                        .background(Color.white.opacity(0.01)).frame(width: 300.0)

                }
            )
        }
    }

}

struct ExerciseRightSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRightSidebarView()
    }
}

// Display result of test run
//
//  Created by Kirk Agbenyegah on 07/02/2023.
//

import SwiftUI
import ExercismSwift

struct TestRunResultView: View {
    let testRun: TestRun
    var body: some View {
        if case let .pass = testRun.status {
            TestPassed()
        } else {
            TestRunSummaryHeader(testRun: testRun)
            TestGroupedByTaskList(testRun: testRun)
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
            VStack(alignment: .leading) {
                CollapsibleTest(test: testGroup.first!.tests!.first!.test!, testId: 1, collapsed: true)
                List(testGroup, children: \.tests) { group in
                    if let task = group.task {
                        HStack {
                            Text("Task \(String(describing: task.id))")
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .textFieldStyle(.roundedBorder)
                                .background(group.passed(taskId: task.id) ? Color.green : Color.lightGold)
                                .foregroundColor(Color.white)
                            Text(task.title)
                                .fontWeight(.semibold)
                        }
                    }
                    if let test = group.test {
                        VStack(alignment: .leading) {
                            CollapsibleTest(test: test, testId: test.index ?? group.testId!, collapsed: test.status == .fail)
                        }
                    }
                }
            }
                .padding()
        }
    }

    struct CollapsibleTest: View {
        let test: Test
        let testId: Int
        @State var collapsed: Bool = true

        func statusLabel(status: TestStatus) -> some View {
            var label = ""
            var color = Color.red
            switch status {
            case .pass:
                label = "Passed"
                color = .green
                break
            default:
                color = .red
                label = "Failed"
            }

            return Label(
                title: { Text(label) },
                icon: {
                    Image(systemName: "circle.fill")
                        .imageScale(.small)
                        .foregroundColor(color)
                }
            )
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

        @State var showContent: Bool = false


        var body: some View {
            DisclosureGroup(
                isExpanded: $showContent,
                content: {
                    VStack(spacing: 0) {
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
                },

                label: {
                    HStack(alignment: .center) {
                        statusLabel(status: test.status)
                        VStack {
                            Text("Test \(String(describing: testId))")

                            Text(test.name)
                        }
                    }
                        .padding(.bottom, 1)
                        .background(Color.white.opacity(0.01))

                }
            )
        }
    }
}

struct TestRunResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestRunResultView(testRun: PreviewData.shared.testRun())
    }
}

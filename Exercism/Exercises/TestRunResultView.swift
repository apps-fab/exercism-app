// Display result of test run
//
//  Created by Kirk Agbenyegah on 07/02/2023.
//

import SwiftUI
import ExercismSwift
import MarkdownUI
import Splash

struct TestRunResultView: View {
    let testRun: TestRun
    let language: String
    let theme: Splash.Theme

    let onSubmitTest: () -> Void
    var body: some View {
        switch testRun.status {
        case .pass:
            TestPassed(onSubmitTest: onSubmitTest)
        case .error, .ops_error, .timeout:
            TestErrored()
        case .fail:
            VStack {
                TestRunSummaryHeader(testRun: testRun)
                ScrollView {
                    TestGroupedByTaskList(testRun: testRun, language: language, theme: theme)
                }
            }

        default:
            TestRunSummaryHeader(testRun: testRun)
        }
    }

    struct TestPassed: View {
        let onSubmitTest: () -> Void
        var body: some View {
            VStack {
                Text("Sweet. Looks like you’ve solved the exercise!")
                Text("""
                      Good job! You can continue to improve your code or, if you're
                     done, submit an iteration to get automated feedback and optionally request mentoring.
                     """)
                Button(action: {
                    onSubmitTest()
                }, label: { // 1
                    Label("Submit", systemImage: "play")
                })
            }
        }
    }

    struct TestErrored: View {
        var body: some View {
            VStack {
                Text("AN ERROR OCCURRED.")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                Text("""
                      An error occurred while running your tests.
                     This might mean that there was an issue in Exercism infrastructure, or it might mean that you have something in your code that's causing our systems to break.

                     Please check your code, and if nothing seems to be wrong, try running the tests again.
                     """)
            }
        }
    }

    struct TestRunSummaryHeader: View {
        let testRun: TestRun
        var headerText = ""
        var color = SwiftUI.Color.green

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
            Label(headerText, systemImage: "circle.fill")
                .frame(maxWidth: .infinity)
                .padding()
                .background(testRun.status == .pass ? .green : .red.opacity(0.2))
                .foregroundColor(testRun.status == .pass ? .green : .red)
                .bold()
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
        }
    }

    struct TestGroupedByTaskList: View {
        let testRun: TestRun
        let language: String
        let theme: Splash.Theme
        @State var collapsed: Bool = true

        var body: some View {
            let testGroup = testRun.testGroupedByTaskList()
            let firstTest = testGroup.first?.first?.tests
            let title = firstTest != nil ? "Task" : "Test"

            VStack(alignment: .leading) {
                ForEach(testGroup, id: \.self) { groupArray in
                    DisclosureGroup {
                        VStack {
                            ForEach(groupArray, id: \.self) { group in
                                if let task = group.task {
                                    HStack {
                                        Text("\(title) \(String(describing: task.id))")
                                            .fontWeight(.bold)
                                            .textCase(.uppercase)
                                            .textFieldStyle(.roundedBorder)
                                            .background(group.passed(taskId: task.id) ? Color.green : Color.lightGold)
                                            .foregroundColor(Color.white)
                                        Text(task.title)
                                            .fontWeight(.semibold)
                                    }
                                }

                                if let test = group.test, let id = group.testId  {
                                    CollapsibleTestDetailView(test: test, testId: id, language: language, theme: theme)
                                }
                            }
                        }
                    } label: {
                        disclosureLabel(groupArray)
                    }
                }
            }.padding()
        }

        func disclosureLabel(_ tests: [TestGroup]) -> some View {
            let title: String
            let icon: Image
            let color: SwiftUI.Color

            switch tests[0].test?.status  {
            case .pass:
                title = "\(tests.count) \(tests.count > 1 ? "tests": "test") passed"
                icon = Image(systemName: "checkmark.circle.fill")
                color = .green

            default:
                title = "\(tests.count) \(tests.count > 1 ? "tests": "test") failed"
                icon = Image(systemName: "x.circle")
                color = .red

            }

            return Label {
                Text(title)
            } icon: {
                icon.foregroundColor(color)
            }
        }
}

struct CollapsibleTestDetailView: View {
    let test: Test
    let testId: Int
    let language: String
    let theme: Splash.Theme
    @State var collapsed: Bool = true
    @State var showContent: Bool = false


    func statusLabel(status: TestStatus) -> some View {
        var label = ""
        var color = SwiftUI.Color.red
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
            title: { Text(label)
                    .textCase(.uppercase)
                    .foregroundColor(color)
            },
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



    var body: some View {
        DisclosureGroup(
            isExpanded: $showContent,
            content: {
                VStack(alignment: .leading, spacing: 0) {
                    if let testCode = test.testCode, !testCode.isEmpty {
                        Text("Code Run").textCase(.uppercase).bold()
                        Markdown(testCode)
                            .padding()
                            .markdownTheme(.gitHub)
                            .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
                    }

                    if let messageHtml = test.messageHtml, !messageHtml.isEmpty {
                        Text(messageLabel(status: test.status))
                            .textCase(.uppercase).bold()
                        Markdown(messageHtml)
                            .padding()
                            .markdownTheme(.gitHub)
                    }

                    if let outputHtml = test.outputHtml, !outputHtml.isEmpty {
                        Text("Your Output")
                        Text(outputHtml)
                    }
                }.padding()
            },

            label: {
                HStack(alignment: .center) {
                    statusLabel(status: test.status)
                    VStack(alignment: .leading) {
                        Text("Test \(String(describing: testId))")
                            .foregroundColor(.gray)
                        Text(test.name)
                    }
                }
                .padding(.bottom, 1)
                .background(Color.white.opacity(0.01))

            }
        ).roundEdges(cornerRadius: 4)
    }
}
}

struct TestRunResultView_Previews: PreviewProvider {
    static var previews: some View {
        TestRunResultView(testRun: PreviewData.shared.testRun(), language: "Swift", theme: .midnight(withFont: .init(size: 10)), onSubmitTest: {})
    }
}

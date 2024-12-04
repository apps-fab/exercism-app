//
//  TestGroupedByTaskList.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//

import SwiftUI
import ExercismSwift
import Splash

struct TestGroupedByTaskList: View {
    var testRun: TestRun
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
                                        .background(group.passed(taskId: task.id) ?
                                                    Color.green : Color.appLightGold)
                                        .foregroundColor(Color.white)
                                    Text(task.title)
                                        .fontWeight(.semibold)
                                }
                            }

                            if let test = group.test, let id = group.testId {
                                CollapsibleTestDetailView(test: test, testId: id, language: language, theme: theme)
                            }
                        }
                    }
                } label: {
                    disclosureLabel(groupArray)
                }
            }
            Text(testRun.message ?? "Unknown")

        }.padding()
    }

    func disclosureLabel(_ tests: [TestGroup]) -> some View {
        let title: String
        let icon: Image
        let color: SwiftUI.Color

        switch tests[0].test?.status {
        case .pass:
            title = "\(tests.count) \(tests.count > 1 ? "tests": "test") passed"
            icon = Image.checkmarkSquareFill
            color = .green

        default:
            title = "\(tests.count) \(tests.count > 1 ? "tests": "test") failed"
            icon = Image.xCircle
            color = .red

        }

        return Label {
            Text(title)
        } icon: {
            icon.foregroundColor(color)
        }
    }
}

#Preview("Test Grouped") {
    TestGroupedByTaskList(testRun: PreviewData.shared.testRun(),
                          language: "Swift",
                          theme: Splash.Theme.wwdc18(withFont: Font(size: 18)))
}

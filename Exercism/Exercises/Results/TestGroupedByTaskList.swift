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
    @State private var isExpanded: Bool = true

    var body: some View {
        let testGroups = testRun.testGroupedByTaskList()

        VStack(alignment: .leading) {
            ForEach(testGroups, id: \.self) { groupArray in
                if testRun.hasTasks() {
                    groupedTestsView(groupArray)
                } else {
                    ungroupedTestsView(groupArray)
                }
                Divider()
            }

            if let message = testRun.message {
                Text(message).padding()
            }
        }
    }

    @ViewBuilder
    private func groupedTestsView(_ groupArray: [TestGroup]) -> some View {
        DisclosureGroup {
            ForEach(groupArray, id: \.self) { group in
                if let test = group.test, let id = group.testId {
                    CollapsibleTestDetailView(test: test,
                                              testId: id,
                                              language: language,
                                              theme: theme)
                    .padding()
                }
            }
        } label: {
            taskHeader(for: groupArray)
        }
    }

    @ViewBuilder
    private func ungroupedTestsView(_ tests: [TestGroup]) -> some View {
        DisclosureGroup {
            ForEach(tests, id: \.self) { group in
                if let test = group.test, let id = group.testId {
                    CollapsibleTestDetailView(test: test,
                                              testId: id,
                                              language: language,
                                              theme: theme)
                    .padding()
                }
            }
        } label: {
            disclosureLabel(for: tests)
        }
    }

    private func taskHeader(for groupArray: [TestGroup]) -> some View {
        HStack {
            if let task = groupArray.first?.task {
                let isPassed = groupArray.allSatisfy { $0.passed(taskId: task.id) }

                Text("Task \(task.id)".uppercased())
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 7)
                    .roundEdges(backgroundColor: Color.appAccent, cornerRadius: 7)

                Text(task.title)
                    .fontWeight(.bold)

                Image(systemName: isPassed ? "checkmark.square.fill" : "x.circle.fill")
                    .foregroundStyle(isPassed ? .green : .red)
            }
        }
    }

    private func disclosureLabel(for tests: [TestGroup]) -> some View {
        let passedTests = tests.filter { $0.test?.status == .pass }.count
        let failedTests = tests.count - passedTests
        let title = passedTests > 0 ?
        "\(passedTests) test\(passedTests > 1 ? "s" : "") passed" :
        "\(failedTests) test\(failedTests > 1 ? "s" : "") failed"
        let icon = passedTests > 0 ? "checkmark.square.fill" : "x.circle"
        let color: SwiftUICore.Color = passedTests > 0 ? Color.green : Color.red

        return Label(title, systemImage: icon).foregroundColor(color)
    }
}

#Preview("Test Grouped") {
    TestGroupedByTaskList(testRun: PreviewData.shared.testRun(),
                          language: "Swift",
                          theme: Splash.Theme.wwdc18(withFont: Font(size: 18)))
}

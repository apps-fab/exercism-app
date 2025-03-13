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

        VStack(alignment: .leading) {
            ForEach(testGroup, id: \.self) { groupArray in
                DisclosureGroup {
                    ForEach(groupArray, id: \.self) { group in
                        if let test = group.test, let id = group.testId {
                            CollapsibleTestDetailView(test: test,
                                                      testId: id,
                                                      language: language,
                                                      theme: theme)
                        }
                    }

                } label: {
                    HStack {
                        if let tasks = groupArray.first?.task {
                            Text("Task \(tasks.id)".uppercased())
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 7)
                                .roundEdges(backgroundColor: Color.appAccent, cornerRadius: 7)
                            Text(tasks.title)
                        }
                    }
                }

                if let message = testRun.message {
                    Text(message)
                }
            }.padding()
        }
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

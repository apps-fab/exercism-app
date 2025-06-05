//
//  CollapsibleTestDetailView.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//

import SwiftUI
import MarkdownUI
import ExercismSwift
import Splash

struct CollapsibleTestDetailView: View {
    @State private var showContent = false
    let test: Test
    let testId: Int
    let language: String
    let theme: Splash.Theme

    var body: some View {
        DisclosureGroup(
            isExpanded: $showContent,
            content: {
                VStack(alignment: .leading, spacing: 0) {
                    if let testCode = test.testCode, !testCode.isEmpty {
                        Text(Strings.codeRun.localized())
                            .textCase(.uppercase)
                            .bold()
                            .padding()

                        Markdown(testCode)
                            .roundEdges(backgroundColor: Color.appDarkBackground,
                                        lineColor: .clear,
                                        cornerRadius: 7)
                            .markdownTheme(.docC)
                            .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
                    }

                    if let messageHtml = test.messageHtml, !messageHtml.isEmpty {
                        Text(messageLabel(status: test.status))
                            .padding()
                            .textCase(.uppercase)
                            .bold()

                        Markdown(messageHtml)
                            .roundEdges(backgroundColor: Color.appDarkBackground,
                                        lineColor: .clear,
                                        cornerRadius: 7)
                            .markdownTheme(.docC)
                    }

                    if let outputHtml = test.outputHtml, !outputHtml.isEmpty {
                        Text(Strings.output.localized())
                        Text(outputHtml)
                    }
                }.padding()
            }, label: {
                HStack(alignment: .center) {
                    statusLabel(status: test.status)
                    VStack(alignment: .leading) {
                        Text(String(format: Strings.testNumber.localized(), testId))
                            .foregroundColor(.gray)
                        Text(test.name)
                    }.font(.headline)
                        .bold()
                }
                .padding(.bottom, 1)
                .background(Color.white.opacity(0.01))

            }
        ).roundEdges(cornerRadius: 4)
    }

    private func statusLabel(status: TestStatus) -> some View {
        var label = ""
        var color = SwiftUI.Color.red
        switch status {
        case .pass:
            label =  Strings.passed.localized()
            color = .green
        default:
            color = .red
            label = Strings.failed.localized()
        }

        return Label(
            title: { Text(label)
                    .textCase(.uppercase)
                    .foregroundColor(color)
            },
            icon: {
                Image.circleFill
                    .imageScale(.small)
                    .foregroundColor(color)
            }
        )
    }

    private func messageLabel(status: TestStatus) -> String {
        var label = ""
        switch status {
        case .fail:
            label = Strings.testFailure.localized()
        case .error:
            label = Strings.testError.localized()
        case .pass:
            label = ""
        }

        return label
    }
}

#Preview("Test Collapsible Detail") {
    CollapsibleTestDetailView(test: PreviewData.shared.testRun().tests[0],
                              testId: 0,
                              language: "Swift",
                              theme: Splash.Theme.wwdc18(withFont: Font(size: 18)))
    .frame(height: 400)
}

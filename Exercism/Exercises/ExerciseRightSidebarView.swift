//
//  ExerciseRightSidebarView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 29/09/2022.
//

import SwiftUI
import ExercismSwift
import MarkdownUI
import Splash

struct ExerciseRightSidebarView: View {
    @StateObject var viewModel = ExerciseViewModel.shared
    @EnvironmentObject var settingsData: SettingsModel
    var onMarkAsComplete: (() -> Void)?

    var instruction: String? {
        viewModel.instruction
    }

    private var theme: Splash.Theme {
        switch settingsData.colorScheme {
        case .dark:
            return .wwdc18(withFont: .init(size: settingsData.fontSize))
        default:
            return .sunset(withFont: .init(size: settingsData.fontSize))
        }
    }

    private var language: String {
        return viewModel.language ?? Strings.text.localized()
    }

    var body: some View {
        CustomTabView(selectedItem: $viewModel.selectedTab) {
            if let instruction = instruction {
                let markdownTheme = Theme.gitHub
                VStack(spacing: 0) {
                    InstructionView(instruction: instruction,
                                    theme: theme,
                                    language: language,
                                    markdownTheme: markdownTheme)

                    if let onMarkAsComplete {
                        Button(action: onMarkAsComplete) {
                            Label {
                                Text(Strings.markAsComplete.localized())
                            } icon: {
                                Image.checkmarkSeal
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(Color.appAccent, in: .rect(cornerRadius: 15))
                            .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                .background(markdownTheme.textBackgroundColor)
                .tabItem(for: SelectedTab.instruction)

            }
            VStack(alignment: HorizontalAlignment.leading) {
                if let averageTestDuration = viewModel.averageTestDuration {
                    TestRunProgress(totalSecs: averageTestDuration)
                } else {
                    if let testRun = viewModel.testRun {
                        TestRunResultView(
                            testRun: testRun,
                            language: language,
                            theme: theme,
                            onSubmitTest: {
                                viewModel.submitSolution()
                            }
                        )
                    } else {
                        NoTestRun()
                    }
                }
            }
            .tabItem(for: SelectedTab.result)
        }
    }

    struct InstructionView: View {
        let instruction: String
        let theme: Splash.Theme
        let language: String
        let markdownTheme: MarkdownUI.Theme

        var body: some View {
            ScrollView {
                Markdown(instruction)
                    .markdownBlockStyle(\.codeBlock, body: { configuration in
                        configuration.label
                            .padding()
                            .overlay(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.secondary)
                                    .frame(width: 1)
                            }
                            .background(Color.appPrimaryBackground)
                    })
                    .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
                    .markdownTheme(markdownTheme)
            }
        }

    }

    struct TabLabel: View {
        let image: Image
        let label: Text

        var body: some View {
            HStack {
                image
                label
            }
        }
    }

    struct NoTestRun: View {
        var body: some View {
            VStack {
                Image.gear
                Text(Strings.runTestsTitle.localized())
                Text(Strings.runTestsDescription.localized())
                    .multilineTextAlignment(.center)
            }.padding()
        }
    }

    struct TestRunProgress: View {
        let totalSecs: Double
        @State private var progress = 0.0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
            VStack {
                ProgressView(Strings.runningTests.localized(), value: progress, total: 100)
                    .tint(Color.appAccent)
                    .padding()
                    .onReceive(timer) { _ in
                        if progress < 100 {
                            progress += ((100.0 / (totalSecs * 10.0))).rounded(.towardZero)
                        }
                    }
                Text(String(format: Strings.estimatedTime.localized(), Int(totalSecs)))
            }
        }
    }
}

#Preview("Instruction View") {
    ExerciseRightSidebarView.InstructionView(instruction: "some instructions",
                                             theme: Splash.Theme.wwdc17(withFont: .init(size: 12)),
                                             language: "Swift",
                                             markdownTheme: .gitHub)
}

#Preview("Test Run Progress View") {
        ExerciseRightSidebarView.TestRunProgress(totalSecs: 10)
}

#Preview("No Test Run View") {
    ExerciseRightSidebarView.NoTestRun()
}

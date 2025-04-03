//
//  ExerciseRightSidebarView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 29/09/2022.
//

import SwiftUI
import ExercismSwift
import Splash
import MarkdownUI

struct ExerciseRightSidebarView: View {
    @EnvironmentObject var viewModel: ExerciseViewModel
    @AppSettings(\.general) private var general

    private var theme: Splash.Theme {
        switch general.appAppearance {
        case .dark:
            return .wwdc18(withFont: .init(size: general.fontSize))
        case .system:
            return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            ? .wwdc18(withFont: .init(size: general.fontSize))
            : .sunset(withFont: .init(size: general.fontSize))
        default:
            return .sunset(withFont: .init(size: general.fontSize))
        }
    }

    private var language: String {
        return viewModel.language ?? Strings.text.localized()
    }

    var body: some View {
        CustomTabView(selectedItem: $viewModel.selectedTab) {
            if let instruction = viewModel.instruction {
                let markdownTheme = Theme.gitHub
                VStack(spacing: 0) {
                    InstructionView(instruction: instruction,
                                    theme: theme,
                                    language: language,
                                    markdownTheme: markdownTheme)

                    if viewModel.canMarkAsComplete {
                        Button {
                            viewModel.showPublishModal = true
                        } label: {
                            Label {
                                Text(Strings.markAsComplete.localized())
                            } icon: {
                                Image.checkmarkSeal
                            }.frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color.appAccent, in: .rect(cornerRadius: 15))
                                .foregroundStyle(.white)
                        }.buttonStyle(.plain)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                .background(markdownTheme.textBackgroundColor)
                .tabItem(for: SelectedTab.instruction)
            }

            if let tests = viewModel.tests, let language = viewModel.language {
                VStack {
                    TestsView(tests: tests,
                              language: language)
                    .padding()
                }.tabItem(for: SelectedTab.tests)
            }
            VStack(alignment: HorizontalAlignment.leading) {
                ResultView(language: language,
                           theme: theme)
            }.tabItem(for: SelectedTab.result)
        }.sheet(isPresented: $viewModel.showPublishModal) {
            SubmitSolutionContentView().environmentObject(viewModel)
        }.alert(String(Strings.submissionAlert.localized()),
                isPresented: $viewModel.showErrorAlert) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(viewModel.runStatus.description)
        }
    }
}

#Preview {
    let solution = PreviewData.shared.getSolutions().first
    ExerciseRightSidebarView()
        .environmentObject(ExerciseViewModel("Swift", "Hello-world", solution))
}

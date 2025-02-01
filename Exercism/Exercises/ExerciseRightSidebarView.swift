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
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @AppSettings(\.appAppearance) private var appAppearance
    @AppSettings(\.theme) private var themeData
    @AppSettings(\.fontSize) private var fontSize
    var onMarkAsComplete: (() -> Void)?

    private var theme: Splash.Theme {
        switch appAppearance {
        case .dark:
            return .wwdc18(withFont: .init(size: fontSize))
        default:
            return .sunset(withFont: .init(size: fontSize))
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
                ResultView(language: language, theme: theme)
            }
            .tabItem(for: SelectedTab.result)
        }
    }
}

#Preview {
    ExerciseRightSidebarView()
}

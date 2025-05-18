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
    @EnvironmentObject var actionsVM: EditorActionsViewModel
    @AppSettings(\.general) private var general
    @State var showCompleteExerciseModal = false

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
        CustomTabView(selectedItem: $actionsVM.selectedTab) {
            if let instruction = viewModel.instruction {
                let markdownTheme = Theme.gitHub
                InstructionView(instruction: instruction,
                                theme: theme,
                                language: language,
                                markdownTheme: markdownTheme,
                                presentModal: $showCompleteExerciseModal)
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
        }.sheet(isPresented: $showCompleteExerciseModal) {
            CompleteSolutionContentView()
        }
    }
}

#Preview {
    ExerciseRightSidebarView()
        .environmentObject(ExerciseViewModel("Swift", "Hello-world"))
        .environmentObject(EditorActionsViewModel(solutionUUID: "", exerciseItem: nil, iterations: []))
}

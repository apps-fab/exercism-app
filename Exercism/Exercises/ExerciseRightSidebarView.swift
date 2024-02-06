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
    @EnvironmentObject var settingData: SettingData
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
    var onMarkAsComplete: (() -> Void)?
    
    var instruction: String? {
        viewModel.instruction
    }
    
    private var theme: Splash.Theme {
        switch colorScheme {
        case .dark:
            return .wwdc18(withFont: .init(size: settingData.fontSize))
        default:
            return .sunset(withFont: .init(size: settingData.fontSize))
        }
    }
    
    private var language: String {
        return viewModel.language ?? Strings.text.localized()
    }
    
    var body: some View {
        
        CustomTabView(selectedItem: $viewModel.selectedTab) {
            if let instruction = instruction {
                let markdownTheme = Theme.gitHub
                // TODO: @savekirk: Use system colorScheme
                VStack(spacing: 0) {
                    InstructionView(instruction: instruction, 
                                    theme: theme,
                                    language: language,
                                    markdownTheme: markdownTheme)
                    
                    if let onMarkAsComplete {
                        Button(action: onMarkAsComplete) {
                            Label("Mark as complete", systemImage: "checkmark.seal")
                                .frame(maxWidth: .infinity)
                                .frame(height: 45)
                                .background(Color.exercismPurple, in: RoundedRectangle(cornerRadius: 15))
                        }
                        .buttonStyle(.plain)
                        .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                .background(markdownTheme.textBackgroundColor)
                .tabItem(for: SelectedTab.Instruction)

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
            .tabItem(for: SelectedTab.Result)
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
                    .markdownTheme(markdownTheme)
                    .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
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
                    .tint(.exercismPurple)
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

struct ExerciseRightSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExerciseRightSidebarView.InstructionView(instruction: "some instructions", theme: Splash.Theme.wwdc17(withFont: .init(size: 12)), language: "Swift", markdownTheme: .gitHub)
            
            ExerciseRightSidebarView.TestRunProgress(totalSecs: 10)
        }
    }
}


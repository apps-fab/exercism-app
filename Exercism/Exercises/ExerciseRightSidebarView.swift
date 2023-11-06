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
                // Todo(savekirk): Use system colorScheme
                Instruction(instruction: instruction, theme: theme, language: language)
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

    struct Instruction: View {
        let instruction: String
        let theme: Splash.Theme
        let language: String
        let markdownTheme = Theme.gitHub

        var body: some View {
            ScrollView {
                    Markdown(instruction)
                    .markdownTheme(.gitHub)
                    .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
            }
            .padding()
            .background(markdownTheme.textBackgroundColor)
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
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            VStack {
                ProgressView(Strings.runningTests.localized(), value: progress, total: 100)
                    .padding()
                    .onReceive(timer) { _ in
                        if progress < 100 {
                            print("This is the progress: \(progress)")
                            progress += ((100.0 / (totalSecs * 10.0))).rounded(.towardZero)
                        }
                    }
                Text(String(format: Strings.estimatedTime.localized(), totalSecs))
            }
        }
    }
}

struct ExerciseRightSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRightSidebarView.Instruction(instruction: "some instructions", theme: Splash.Theme.wwdc17(withFont: .init(size: 12)), language: "Swift")
    }
}


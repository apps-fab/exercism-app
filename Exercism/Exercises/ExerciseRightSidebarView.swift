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
    @EnvironmentObject var exerciseObject: ExerciseViewModel
    @SwiftUI.Environment(\.colorScheme) private var colorScheme
    
    var instruction: String? {
        exerciseObject.instruction
    }
    
    private var theme: Splash.Theme {
        switch colorScheme {
        case .dark:
            return .wwdc18(withFont: .init(size: 16))
        default:
            return .sunset(withFont: .init(size: 16))
        }
    }
    
    private var language: String {
        return exerciseObject.exercise?.language ?? Strings.text.localized()
    }
    
    var body: some View {
        TabView(selection: $exerciseObject.selectedTab) {
            if let instruction = instruction {
                // Todo(savekirk): Use system colorScheme
                Instruction(instruction: instruction, theme: theme, language: language)
                    .tabItem {
                        TabLabel(image: Image.checklist,
                                 label: Text(Strings.instructions.localized()))
                    }.tag(0)
            }
            VStack(alignment: HorizontalAlignment.leading) {
                if let averageTestDuration = exerciseObject.averageTestDuration {
                    TestRunProgress(totalSecs: averageTestDuration)
                } else {
                    if let testRun = exerciseObject.testRun {
                        TestRunResultView(testRun: testRun,
                                          language: language,
                                          theme: theme,
                                          onSubmitTest: { exerciseObject.submitSolution() })
                    } else {
                        NoTestRun()
                    }
                }
            }
            .tabItem {
                TabLabel(image: Image.textBadgeChecklist,
                         label: Text(Strings.results.localized()))
            }.tag(1)
        }
    }
    
    struct Instruction: View {
        let instruction: String
        let theme: Splash.Theme
        let language: String
        
        var body: some View {
            VStack {
                ScrollView {
                    Markdown(instruction)
                        .markdownTheme(.gitHub)
                        .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
                }
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
            }
        }
    }
    
    struct TestRunProgress: View {
        let totalSecs: Double
        @State private var progress = 0.0
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
        var body: some View {
            VStack {
                ProgressView(Strings.runningTests.localized(), value: progress, total: 100)
                    .onReceive(timer) { _ in
                        if progress < 100 {
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
        ExerciseRightSidebarView()
    }
}

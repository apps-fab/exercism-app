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
        return exerciseObject.exercise?.language ?? "text"
    }

    var body: some View {
        TabView(selection: $exerciseObject.selectedTab) {
            if let instruction = instruction {
                // Todo(savekirk): Use system colorScheme
                Instruction(instruction: instruction, theme: theme, language: language)
                    .tabItem {
                        TabLabel(imageName: "checklist", label: "Instructions")
                    }.tag(0)
            }
            VStack(alignment: HorizontalAlignment.leading) {
                if let averageTestDuration = exerciseObject.averageTestDuration {
                    TestRunProgress(totalSecs: averageTestDuration)
                } else {
                    if let testRun = exerciseObject.testRun {
                        TestRunResultView(testRun: testRun, language: language, theme: theme, onSubmitTest: {
                            exerciseObject.submitSolution() })
                    } else {
                        NoTestRun()
                    }
                }
            }
                .tabItem {
                    TabLabel(imageName: "text.badge.checkmark", label: "Results")
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
        let imageName: String
        let label: String

        var body: some View {
            HStack {
                Image(systemName: imageName)
                Text(label)
            }
        }
    }

    struct NoTestRun: View {
        var body: some View {
            VStack {
                Image(systemName: "doc.badge.gearshape")
                Text("Run tests to check your code")
                Text("We'll run your code against tests to check whether it works, then give you the results here.")
            }
        }
    }

    struct TestRunProgress: View {
        let totalSecs: Double
        @State private var progress = 0.0
        let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
            VStack {
                ProgressView("Running tests...", value: progress, total: 100)
                    .onReceive(timer) { _ in
                        if progress < 100 {
                            progress += ((100.0 / (totalSecs * 10.0))).rounded(.towardZero)
                        }
                    }
                Text("Estimated running time ~ \(totalSecs)s")
            }
        }
    }
}

struct ExerciseRightSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRightSidebarView()
    }
}

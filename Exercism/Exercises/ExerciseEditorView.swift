//
//  ExerciseEditorView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import CodeEditor

struct ExerciseEditorView: View {
    @State private var codeChanged = false
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @AppSettings(\.general) private var general

    private var language: CodeEditor.Language {
        CodeEditor.Language.init(rawValue: viewModel.language ?? "")
    }

    var body: some View {
        VStack {
#if os(macOS)
            CodeEditor(source: $viewModel.selectedCode,
                       language: language,
                       theme: general.theme)
#else
            CodeEditor(source: $viewModel.selectedCode,
                       language: language,
                       theme: settingData.theme)
#endif
            Divider()
            HStack {
                Picker(Strings.theme.localized(), selection: $general.theme) {
                    ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                        Text(theme.rawValue.capitalized)
                    }
                }
            }
            .padding()
        }.alert(String(Strings.submissionAlert.localized()),
                isPresented: $viewModel.showTestSubmissionResponseMessage) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(viewModel.runStatus.description)
        }.onReceive(NotificationCenter.default.publisher(for: NSApplication.didResignActiveNotification)) { _ in
            viewModel.updateFile()
        }
    }
}

#Preview {
    ExerciseEditorView()
        .environmentObject(ExerciseViewModel("Swift", "Hello-world"))
}

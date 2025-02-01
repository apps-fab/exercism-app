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
    @AppSettings(\.appAppearance) private var appAppearance
    @AppSettings(\.theme) private var themeData
    @AppSettings(\.fontSize) private var fontSize

    private var language: CodeEditor.Language {
        CodeEditor.Language.init(rawValue: viewModel.language ?? "")
    }
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
#if os(macOS)
            CodeEditor(source: $viewModel.selectedCode,
                       language: language,
                       theme: themeData)
            .onChange(of: viewModel.selectedCode) { code in
                codeChanged = true
                viewModel.updateCode(code)
            }
            .onReceive(timer) { _ in
                if codeChanged && viewModel.updateFile() {
                    codeChanged = false
                }
            }
#else
            CodeEditor(source: $viewModel.selectedCode, language: language, theme: settingData.theme)
#endif
            Divider()
            HStack {
                Picker(Strings.theme.localized(), selection: $themeData) {
                    ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                        Text(theme.rawValue.capitalized)
                    }
                }
            }
            .padding()
        }.alert(String(Strings.submissionAlert.localized()), isPresented: $viewModel.showTestSubmissionResponseMessage) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(viewModel.operationStatus.description)
        }
        .alert(viewModel.alertItem.title, isPresented: $viewModel.alertItem.isPresented) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(viewModel.alertItem.message)
        }
    }
}

#Preview {
    ExerciseEditorView()
}

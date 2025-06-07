//
//  ExerciseEditorView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import CodeEditor

struct ExerciseEditorView: View {
    @State private var cachedLanguage: CodeEditor.Language = .swift
    @State private var codeChanged = false
    @EnvironmentObject private var viewModel: ExerciseViewModel
    @EnvironmentObject private var actionsVM: EditorActionsViewModel
    @AppSettings(\.general) private var general

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
#if os(macOS)
            CodeEditor(source: $viewModel.selectedCode,
                       language: cachedLanguage,
                       theme: general.theme)
            .onChange(of: viewModel.selectedCode) { _ in
                codeChanged = true
            }
            .onReceive(timer) { _ in
                if codeChanged && viewModel.updateFile() {
                    codeChanged = false
                }
            }
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
                            .tag(theme)
                    }
                }
                .accessibilityLabel(Text(Strings.theme.localized()))
                .accessibilityValue(Text(general.theme.description))
                .accessibilityHint(Text("Click to change the theme"))
            }.padding()
        }.alert(String(Strings.submissionAlert.localized()),
                isPresented: $actionsVM.showErrorAlert) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(actionsVM.errorMessage)
        }
        .onChange(of: viewModel.language) { newValue in
            cachedLanguage = CodeEditor.Language(rawValue: newValue ?? "")
        }
    }
}

#Preview {
    ExerciseEditorView()
        .environmentObject(ExerciseViewModel("Swift", "Hello-world"))
        .environmentObject(EditorActionsViewModel(solutionUUID: "", exerciseItem: nil, iterations: []))
}

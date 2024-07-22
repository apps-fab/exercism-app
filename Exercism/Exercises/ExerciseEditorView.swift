//
//  ExerciseEditorView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
@preconcurrency import CodeEditor

struct ExerciseEditorView: View {
    @State private var exerciseViewModel = ExerciseViewModel.shared
    @State private var codeChanged = false
    @EnvironmentObject var settingData: SettingData

    private var source: String {
        exerciseViewModel.getSelectedCode() ?? Strings.noFile.localized()
    }
    private var language: CodeEditor.Language {
        CodeEditor.Language.init(rawValue: exerciseViewModel.language ?? "")
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
#if os(macOS)
            CodeEditor(
                source: $exerciseViewModel.selectedCode,
                language: language,
                theme: settingData.theme,
                fontSize: .init(get: { CGFloat(settingData.fontSize) },
                                set: { settingData.fontSize = Double($0) }))
            .onChange(of: exerciseViewModel.selectedCode) { code in
                codeChanged = true
                exerciseViewModel.updateCode(code)
            }
            .onReceive(timer) { _ in
                if codeChanged && exerciseViewModel.updateFile() {
                    codeChanged = false
                }
            }
#else
            CodeEditor(source: source, language: language, theme: settingData.theme)
#endif
            
            Divider()
            
            HStack {
                Picker(Strings.theme.localized(), selection: $settingData.theme) {
                    ForEach(CodeEditor.availableThemes) { theme in
                        Text(theme.rawValue.capitalized)
                            .tag(theme)
                    }
                }
            }
            .padding()
        }
        .alert(String(Strings.submissionAlert.localized()), isPresented: $exerciseViewModel.showTestSubmissionResponseMessage) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(exerciseViewModel.operationStatus.description)
        }
        .alert(exerciseViewModel.alertItem.title, isPresented: $exerciseViewModel.alertItem.isPresented) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(exerciseViewModel.alertItem.message)
        }
    }
}

#Preview {
    ExerciseEditorView().environmentObject(SettingData())
}

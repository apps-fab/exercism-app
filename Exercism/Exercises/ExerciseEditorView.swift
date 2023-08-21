//
//  ExerciseEditorView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 28/09/2022.
//

import SwiftUI
import CodeEditor

struct ExerciseEditorView: View {
    @EnvironmentObject var exerciseObject: ExerciseViewModel
    @EnvironmentObject var settingData: SettingData
#if os(macOS)
    @AppStorage("fontsize") var fontSize = Int(NSFont.systemFontSize)
#endif
    private var source: String {
        exerciseObject.getSelectedCode() ?? Strings.noFile.localized()
    }
    private var language: CodeEditor.Language {
        CodeEditor.Language.init(rawValue: exerciseObject.exercise?.language ?? Strings.text.localized())
    }
    
    @State var codeChanged = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var show = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            
#if os(macOS)
            CodeEditor(
                source: $exerciseObject.selectedCode,
                language: language,
                theme: settingData.theme,
                fontSize: .init(get: { CGFloat(fontSize) },
                                set: { fontSize = Int($0) }))
            .onChange(of: exerciseObject.selectedCode) { code in
                codeChanged = true
                exerciseObject.updateCode(code)
            }
            .onReceive(timer) { _ in
                if codeChanged && exerciseObject.updateFile() {
                    codeChanged = false
                }
            }
#else
            CodeEditor(source: source, language: language, theme: theme)

#endif
            
            Divider()
            
            HStack {
                Picker(Strings.theme.localized(), selection: $settingData.theme) {
                    ForEach(CodeEditor.availableThemes) { theme in
                        Text("\(theme.rawValue.capitalized)")
                            .tag(theme)
                    }
                }
            }
            .padding()
        }
        .alert(String(Strings.submissionAlert.localized()), isPresented: $exerciseObject.showTestSubmissionResponseMessage) {
            Button(Strings.ok.localized(), role: .cancel) {
            }
        } message: {
            Text(exerciseObject.testSubmissionResponseMessage)
        }
    }
}

struct ExerciseEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseEditorView()
    }
}

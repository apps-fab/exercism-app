//
//  TestsView.swift
//  Exercode
//
//  Created by Angie Mugo on 08/03/2025.
//

import SwiftUI
import CodeEditor

struct TestsView: View {
    let tests: String
    let language: String
    @AppSettings(\.general) private var general

    private var editorLanguage: CodeEditor.Language {
        CodeEditor.Language.init(rawValue: language)
    }
    var body: some View {
        CodeEditor(source: tests, language: editorLanguage, theme: general.theme)
    }
}

#Preview {
    TestsView(tests: "Some tests", language: "Swift")
}

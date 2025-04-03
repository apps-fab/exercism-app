//
//  TestsView.swift
//  Exercode
//
//  Created by Angie Mugo on 08/03/2025.
//

import SwiftUI
import CodeEditor

struct TestsView: View {
    @AppSettings(\.general) private var general
    let tests: String
    let language: String

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

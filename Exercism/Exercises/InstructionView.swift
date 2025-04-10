//
//  InstructionView.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI
import MarkdownUI
import Splash
import CodeEditor

struct InstructionView: View {
    let instruction: String
    let theme: Splash.Theme
    let language: String
    let markdownTheme: MarkdownUI.Theme

    var body: some View {
        ScrollView {
            Markdown(instruction)
                .markdownTheme(markdownTheme)
                .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
        }
    }
}

#Preview {
    InstructionView(instruction: "Try this",
                    theme: Splash.Theme(
                        font: Font(size: 14),
                        plainTextColor: Color.black,
                        tokenColors: [TokenType.string: Color.black],
                    backgroundColor: Color(white: 0.12, alpha: 1)),
                    language: "Swift",
                    markdownTheme: Theme.basic)
}

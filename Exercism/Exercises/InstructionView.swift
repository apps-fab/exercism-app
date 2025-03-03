//
//  InstructionView.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//
import SwiftUI
import MarkdownUI
import Splash

struct InstructionView: View {
    let instruction: String
    let theme: Splash.Theme
    let language: String
    let markdownTheme: MarkdownUI.Theme

    var body: some View {
        ScrollView {
            Markdown(instruction)
                .markdownBlockStyle(\.codeBlock, body: { configuration in
                    configuration.label
                        .padding()
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(Color.secondary)
                                .frame(width: 1)
                        }
                        .background(Color.appPrimaryBackground)
                })
                .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
                .markdownTheme(markdownTheme)
        }
    }
}

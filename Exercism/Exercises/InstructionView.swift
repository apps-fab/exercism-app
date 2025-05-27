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
    @EnvironmentObject var viewModel: EditorActionsViewModel
    @Binding var presentModal: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Markdown(instruction)
                    .markdownTheme(markdownTheme)
                    .markdownCodeSyntaxHighlighter(.splash(theme: theme, language: language))
            }

            if case .submitSuccess = viewModel.state {
                Button {
                    presentModal.toggle()
                } label: {
                    Label {
                        Text(Strings.markAsComplete.localized())
                    } icon: {
                        Image.checkmarkSeal
                    }.frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(Color.appAccent, in: .rect(cornerRadius: 15))
                        .foregroundStyle(.white)
                }.buttonStyle(.plain)
                    .padding(.vertical, 10)
            }
        }
        .padding(.horizontal)
        .background(markdownTheme.textBackgroundColor)
    }
}

#Preview {
    let theme = Splash.Theme(
        font: Font(size: 14),
        plainTextColor: Color.black,
        tokenColors: [TokenType.string: Color.black],
        backgroundColor: Color(white: 0.12, alpha: 1))

    let viewModel = EditorActionsViewModel(solutionUUID: "", exerciseItem: nil, iterations: [])
    viewModel.state = .submitSuccess("")

    return InstructionView(instruction: "Try this",
                    theme: theme,
                    language: "Swift",
                    markdownTheme: Theme.basic, presentModal: .constant(false))
    .environmentObject(viewModel)
}

//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import Splash
import SwiftUI

struct TextOutputFormat: OutputFormat {
    private let theme: Theme

    init(theme: Theme) {
        self.theme = theme
    }

    func makeBuilder() -> Builder {
        Builder(theme: theme)
    }
}

extension TextOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Theme
        private var accumulatedText: [Text]

        fileprivate init(theme: Theme) {
            self.theme = theme
            accumulatedText = []
        }

        mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type] ?? theme.plainTextColor
            accumulatedText.append(Text(token).foregroundColor(.init(color)))
        }

        mutating func addPlainText(_ text: String) {
            accumulatedText.append(
                Text(text).foregroundColor(.init(theme.plainTextColor))
            )
        }

        mutating func addWhitespace(_ whitespace: String) {
            accumulatedText.append(Text(whitespace))
        }

        func build() -> Text {
            accumulatedText.reduce(Text(""), +)
        }
    }
}

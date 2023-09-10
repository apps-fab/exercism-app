//
// Created by Kirk Agbenyegah on 08/04/2023.
//

import MarkdownUI
import Splash
import SwiftUI

struct SplashCodeSyntaxHighlighter: CodeSyntaxHighlighter {
    private let syntaxHighlighter: SyntaxHighlighter<TextOutputFormat>
    private let language: String
    
    init(theme: Splash.Theme, language: String) {
        syntaxHighlighter = SyntaxHighlighter(format: TextOutputFormat(theme: theme))
        self.language = language
    }
    
    func highlightCode(_ content: String, language: String?) -> Text {
        guard language?.lowercased() == language?.lowercased() else {
            return Text(content)
        }
        
        return syntaxHighlighter.highlight(content)
    }
}

extension CodeSyntaxHighlighter where Self == SplashCodeSyntaxHighlighter {
    static func splash(theme: Splash.Theme, language: String) -> Self {
        SplashCodeSyntaxHighlighter(theme: theme, language: language)
    }
}

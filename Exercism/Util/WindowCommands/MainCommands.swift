//
//  MainCommands.swift
//  Exercism
//
//  Created by Angie Mugo on 26/10/2024.
//

import SwiftUI

struct MainCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("About Exercism") {
                NSApplication.shared.orderFrontStandardAboutPanel(
                    options: [
                        NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                            string: "Exercism is a software built off the Exercism web platform.",
                            attributes: [
                                NSAttributedString.Key.font: NSFont.boldSystemFont(
                                    ofSize: NSFont.smallSystemFontSize
                                )
                            ]
                        ),
                        NSApplication.AboutPanelOptionKey(
                            rawValue: "Copyright"
                        ): "© 2023"
                    ] as [NSApplication.AboutPanelOptionKey: Any]
                )
            }
        }
    }
}

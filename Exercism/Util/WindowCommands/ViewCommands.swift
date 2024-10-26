//
//  ViewCommands.swift
//  Exercism
//
//  Created by Angie Mugo on 26/10/2024.
//

import SwiftUI

struct ViewCommands: Commands {

    var body: some Commands {
        CommandGroup(replacing: .appInfo) {
            Button("Toggle Full Screen") {
                if let window = NSApplication.shared.windows.first {
                    window.toggleFullScreen(nil)
                    window.makeKey()
                }
            }
            .keyboardShortcut("F", modifiers: [.control, .command])

            Button("Refresh") {
                let notification = Notification(
                    name: .didRequestRefresh,
                    object: self)
                NotificationCenter.default.post(notification)
            }
            .keyboardShortcut("R")
        }
    }
}

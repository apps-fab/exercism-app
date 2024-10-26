//
//  WindowCommands.swift
//  Exercism
//
//  Created by Angie Mugo on 26/10/2024.
//
import SwiftUI

struct WindowCommands: Commands {
    @Environment(\.openWindow)
    var openWindow

    var body: some Commands {
        CommandGroup(before: .singleWindowList) {
            Button("Exercode") {
                openWindow(id: "MainWindow")
            }
        }
    }
}

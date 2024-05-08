//
//  AppDelegate.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

import AppKit
import Settings
import ExercismSwift

@MainActor
extension Settings.PaneIdentifier {
    static let general = Self("General")
    static let advanced = Self("Advanced")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    private lazy var panes: [SettingsPane]  = [
        exercismSettingsScreen()
    ]
}

//
//  AppDelegate.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

#if os(macOS)
import AppKit
import Settings

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

#else
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController() // Set your initial view controller here
        window?.makeKeyAndVisible()
        return true
    }
}

#endif

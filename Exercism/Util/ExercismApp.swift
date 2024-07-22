//
//  ExercismApp.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder
import ExercismSwift

enum Keys: String {
    case token
}

@main
struct ExercismApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    @StateObject private var settingsData = SettingData()
    @StateObject private var model = TrackModel.shared

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(settingsData)
                .navigationTitle(Strings.exercism.localized())
        }
        #if os(macOS)
        .commands {
            ExercismCommands()
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
                        ] as [NSApplication.AboutPanelOptionKey : Any]
                    )
                }

                Button("Toggle Full Screen") {
                    if let window = NSApplication.shared.windows.first {
                        window.toggleFullScreen(nil)
                        window.makeKey()
                    }
                }
                .keyboardShortcut("F", modifiers: [.control, .command])

            }

            CommandGroup(before: .sidebar) {
                Button("Refresh") {
                    let notification = Notification(
                        name: .didRequestRefresh,
                        object: self)
                    NotificationCenter.default.post(notification)
                }
                .keyboardShortcut("R")
            }
        }
        #endif
    }
}

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
#endif

    @StateObject private var settingsModel = SettingsModel()
    @StateObject private var model = TrackModel.shared
    @AppStorage("settings") var settingsData: Data?

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(settingsModel)
                .task {
                    await performSettingsSetUp()
                }
                .navigationTitle(Strings.exercism.localized())
                .preferredColorScheme(settingsModel.colorScheme == .dark ? .dark : .light)
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
                        ] as [NSApplication.AboutPanelOptionKey: Any]
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

            CommandGroup(before: .windowList) {
                Button("Exercode") {
                    if let window = NSApplication.shared.windows.first {
                        window.makeKeyAndOrderFront(nil)
                    }
                }
            }
        }
#endif
        Settings {
            ExercismSettings().environmentObject(settingsModel)
        }
    }

    private func performSettingsSetUp() async {
        if let settingsData {
            settingsModel.jsonData = settingsData
        }

        for await _ in settingsModel.objectWillChangeSequence {
            settingsData = settingsModel.jsonData
        }
    }
}

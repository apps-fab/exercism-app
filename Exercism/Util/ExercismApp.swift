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
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var settingsData = SettingData()
    @StateObject private var model = TrackModel()
    
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
        .commands {
            ExercismCommands()
            CommandGroup(replacing: .appInfo) {
                Button("About Exercism") {
                    NSApplication.shared.orderFrontStandardAboutPanel(options: [NSApplication.AboutPanelOptionKey.credits: NSAttributedString(string: "Exercism is a software built off the Exercism web platform.",
                                                                                                                                     attributes: [NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)
                                                                ]),
                                                                       NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2023"
                    ] as [NSApplication.AboutPanelOptionKey : Any])
                }
            }
        }
        Settings {
            ExercismSettings().environmentObject(settingsData)
        }
    }
}

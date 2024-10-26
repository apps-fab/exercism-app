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
        Group {
            MainWindow()
#if os(macOS)
            .commands {
                ExercismCommands()
            }
#endif
            Settings {
                ExercismSettings().environmentObject(settingsModel)
            }
        }
    }

}

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
    @ObservedObject var settings = SettingsModel.shared

    var body: some Scene {
        Group {
            MainWindow()
#if os(macOS)
                .commands {
                    ExercismCommands()
                }
#endif
            Settings {
                ExercismSettings()
            }
        }.environment(\.settings, settings.preferences)
    }
}

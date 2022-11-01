//
//  ExercismApp.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

@main
struct ExercismApp: App {
<<<<<<< HEAD
    @StateObject private var settings = SettingData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
            .windowStyle(HiddenTitleBarWindowStyle())
=======
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.hiddenTitleBar)
>>>>>>> main
    }
}

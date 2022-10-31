//
//  ExercismApp.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI

@main
struct ExercismApp: App {
    @StateObject private var settings = SettingData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
            .windowStyle(HiddenTitleBarWindowStyle())
    }
}

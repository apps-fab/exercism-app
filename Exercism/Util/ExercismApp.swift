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
    @StateObject private var coordinator = AppCoordinator()
    
    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .environmentObject(model)
                .environmentObject(settingsData)
                .navigationTitle("Exercism")
        }
    }
}

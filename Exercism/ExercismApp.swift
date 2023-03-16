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
    @StateObject private var settings = SettingData()

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TrackModel(client: ExercismClient(apiToken: ExercismKeychain.shared.get(for: Keys.token.rawValue)!), coordinator: AppCoordinator()))
                .environmentObject(AppCoordinator())
                .navigationTitle("Exercism")
        }
    }

}

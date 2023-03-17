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
        let token = ExercismKeychain.shared.get(for: Keys.token.rawValue)
        let client = ExercismClient(apiToken: token!)
        let fetcher = Fetcher(client: client)
        return WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 800)
                .environmentObject(settings)
                .environmentObject(TrackModel(fetcher: fetcher,
                                              coordinator: AppCoordinator()))
                .environmentObject(AppCoordinator())
                .navigationTitle("Exercism")
        }
    }
}

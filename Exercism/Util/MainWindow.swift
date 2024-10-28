//
//  MainWindow.swift
//  Exercism
//
//  Created by Angie Mugo on 26/10/2024.
//
import SwiftUI
import SDWebImage
import SDWebImageSVGCoder

struct MainWindow: Scene {
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
        Window("", id: "MainWindow") {
            ContentView()
                .environmentObject(model)
                .environmentObject(settingsModel)
                .task {
                    await performSettingsSetUp()
                }
                .navigationTitle(Strings.exercode.localized())
                .preferredColorScheme(settingsModel.colorScheme == .dark ? .dark : .light)
        }.defaultSize(width: 1000, height: 800)
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

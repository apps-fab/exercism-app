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

    @ObservedObject var settings = SettingsModel.shared

    init() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }

    var body: some Scene {
        Window("", id: "MainWindow") {
            ContentView()
                .setupStreak()
                .navigationTitle(Strings.exercode.localized())
        }.defaultSize(width: 1000, height: 800)
    }
}

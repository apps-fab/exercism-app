//
//  ExercismSettings.swift
//  Exercism
//
//  Created by Angie Mugo on 03/08/2023.
//

import SwiftUI
import CodeEditor
import Splash

#if os(macOS)
import Settings

@MainActor
let exercismSettingsScreen: () -> SettingsPane  = {
    let paneView = Settings.Pane(
        identifier: .general,
        title: "General",
        toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "General settings")!
    ) {
        ExercismSettings()
    }

    return Settings.PaneHostingController(pane: paneView)
}

enum ExercismAppearance: String, CaseIterable, Identifiable, Codable {
    var id: Self {
        return self
    }

    case dark = "Dark"
    case light = "Light"
}

struct ExercismSettings: View {
    @EnvironmentObject var settingsModel: SettingsModel

    var body: some View {
        Settings.Container(contentWidth: 400) {
            Settings.Section(title: "Editor Theme") {
                Picker("", selection: $settingsModel.theme) {
                    ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                        Text(theme.rawValue.capitalized)
                    }
                }.labelsHidden()

                Settings.Section(title: "Appearance") {
                    Picker("", selection: $settingsModel.colorScheme) {
                        ForEach(ExercismAppearance.allCases) { appearance in
                            Text("\(appearance.rawValue)")
                        }
                    }.labelsHidden()
                }

                Settings.Section(title: "Font Size") {
                    Picker("", selection: $settingsModel.fontSize) {
                        ForEach(8..<20) { fontSize in
                            Text(fontSize.description).tag(Double(fontSize))
                        }
                    }.labelsHidden()
                }
            }
        }.preferredColorScheme(settingsModel.colorScheme == .dark ? .dark : .light)

    }
}

#Preview {
    ExercismSettings()
}

#endif

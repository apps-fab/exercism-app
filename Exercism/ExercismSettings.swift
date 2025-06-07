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

struct ExercismSettings: View {
    @AppSettings(\.general) private var general

    var body: some View {
        Settings.Container(contentWidth: 400) {
            Settings.Section(title: "Editor Theme") {
                Picker("", selection: $general.theme) {
                    ForEach(CodeEditor.availableThemes, id: \.self) { theme in
                        Text(theme.rawValue.capitalized)
                    }
                }.labelsHidden()

                Settings.Section(title: "Appearance") {
                    Picker("Appearance", selection: $general.appAppearance) {
                        Text("System")
                            .tag(SettingsData.Appearances.system)
                        Divider()
                        Text("Light")
                            .tag(SettingsData.Appearances.light)
                        Text("Dark")
                            .tag(SettingsData.Appearances.dark)
                    }.onChange(of: general.appAppearance) { tag in
                        tag.applyAppearance()
                    }
                }

                Settings.Section(title: "Font Size") {
                    Picker("", selection: $general.fontSize) {
                        ForEach(8..<20) { fontSize in
                            Text(fontSize.description).tag(Double(fontSize))
                        }
                    }.labelsHidden()
                }
            }
        }

    }
}

#Preview {
    ExercismSettings()
}

#endif

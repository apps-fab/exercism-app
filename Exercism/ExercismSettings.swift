//
//  ExercismSettings.swift
//  Exercism
//
//  Created by Angie Mugo on 03/08/2023.
//

import SwiftUI
import Settings
import CodeEditor
import Splash

let exercismSettingsScreen: () -> SettingsPane  = {
    let paneView = Settings.Pane(
        identifier: .general,
        title: "Accounts",
        toolbarIcon: NSImage(systemSymbolName: "person.crop.circle", accessibilityDescription: "Accounts settings")!
    ) {
        ExercismSettings()
    }

    return Settings.PaneHostingController(pane: paneView)
}

struct ExercismSettings: View {
    @EnvironmentObject var settingData: SettingData
    @State private var selectedFont: Int = 0

    var body: some View {
        Settings.Container(contentWidth: 400) {
            Settings.Section(title: "Editor Theme") {
                List(CodeEditor.availableThemes, id: \.self, selection: $settingData.theme) { theme in
                        Text(theme.rawValue.capitalized)
                }
            }

//            Settings.Section(title: "Markdown Theme") {
//                List(Splash.The
//
//            }
            Settings.Section(title: "Font Size") {
                Picker("", selection: $selectedFont) {
                    ForEach(8..<20) { fontSize in
                        Text("\(fontSize)")
                    }
                }
            }
        }
    }
}

struct ExercismSettings_Previews: PreviewProvider {
    static var previews: some View {
        ExercismSettings().environmentObject(SettingData())
    }
}

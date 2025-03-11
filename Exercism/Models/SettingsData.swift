//
//  SettingsData.swift
//  Exercode
//
//  Created by Angie Mugo on 31/01/2025.
//

import CodeEditor
import SwiftUI

struct SettingsData: Codable, Hashable {
    var general: GeneralSettings = .init()

    /// Default initializer
    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.general = try container.decode(GeneralSettings.self, forKey: .general)
    }

    struct GeneralSettings: Codable, Hashable {
        var appAppearance: Appearances = .system
        var fontSize: Double = 14
        var theme: CodeEditor.ThemeName = .default

        /// Default initializer
        init() {}

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.appAppearance = try container.decode(Appearances.self, forKey: .appAppearance)
            self.fontSize = try container.decode(Double.self, forKey: .fontSize)
            self.theme = try container.decode(CodeEditor.ThemeName.self, forKey: .theme)
        }
    }

    /// The appearance of the app
    /// - **system**: uses the system appearance
    /// - **dark**: always uses dark appearance
    /// - **light**: always uses light appearance
    enum Appearances: String, Codable {
        case system
        case light
        case dark

        /// Applies the selected appearance
        func applyAppearance() {
            switch self {
            case .system:
                NSApp.appearance = nil

            case .dark:
                NSApp.appearance = .init(named: .darkAqua)

            case .light:
                NSApp.appearance = .init(named: .aqua)
            }
        }
    }
}

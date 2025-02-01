//
// Created by Kirk Agbenyegah on 01/10/2022.
//

import Foundation
import Combine

final class SettingsModel: ObservableObject {
    static let shared: SettingsModel = .init()
    private var storeTask: AnyCancellable!
    private let fileManager = FileManager.default

    @Published var preferences: SettingsData

    private init() {
        self.preferences = .init()
        self.preferences = loadSettings()

        self.storeTask = self.$preferences.throttle(for: 2, scheduler: RunLoop.main, latest: true).sink {
            try? self.savePreferences($0)
        }
    }

    static subscript<T>(_ path: WritableKeyPath<SettingsData, T>, suite: SettingsModel = .shared) -> T {
        get {
            suite.preferences[keyPath: path]
        }
        set {
            suite.preferences[keyPath: path] = newValue
        }
    }

    private func loadSettings() -> SettingsData {
        if !fileManager.fileExists(atPath: settingsURL.path) {
            try? fileManager.createDirectory(at: baseURL, withIntermediateDirectories: false)
            return .init()
        }

        guard let json = try? Data(contentsOf: settingsURL),
              let prefs = try? JSONDecoder().decode(SettingsData.self, from: json)
        else {
            return .init()
        }
        return prefs
    }

    private func savePreferences(_ data: SettingsData) throws {
        let data = try JSONEncoder().encode(data)
        let json = try JSONSerialization.jsonObject(with: data)
        let prettyJSON = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
        try prettyJSON.write(to: settingsURL, options: .atomic)
    }

    /// The base URL of settings.
    ///
    /// Points to `~/Library/Application Support/Exercode/`
    internal var baseURL: URL {
        fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/Exercode", isDirectory: true)
    }

    /// The URL of the `settings.json` settings file.
    ///
    /// Points to `~/Library/Application Support/CodeEdit/settings.json`
    private var settingsURL: URL {
        baseURL
            .appendingPathComponent("settings")
            .appendingPathExtension("json")
    }
}

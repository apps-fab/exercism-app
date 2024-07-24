//
// Created by Kirk Agbenyegah on 01/10/2022.
//

import Foundation
import CodeEditor
import Combine

final class SettingsModel: ObservableObject, Codable {
    @Published var theme: CodeEditor.ThemeName
    @Published var fontSize: Double
    @Published var appearance: ExercismAppearance

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    init(theme: CodeEditor.ThemeName = CodeEditor.ThemeName.pojoaque,
         fontSize: Double = 12,
         appearance: ExercismAppearance = ExercismAppearance.dark) {
        self.theme = theme
        self.fontSize = fontSize
        self.appearance = appearance
    }

    var jsonData: Data? {
        get { try? encoder.encode(self)}
        set {
            guard let data = newValue, let model = try? decoder.decode(Self.self, from: data)
            else { return }
            theme = model.theme
            fontSize = model.fontSize
            appearance = model.appearance
        }
    }

    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(theme, forKey: .theme)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(appearance, forKey: .appearance)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.theme = try container.decode(CodeEditor.ThemeName.self, forKey: .theme)
        self.fontSize = try container.decode(Double.self, forKey: .fontSize)
        self.appearance = try container.decode(ExercismAppearance.self, forKey: .appearance)
    }

    enum CodingKeys: String, CodingKey {
        case theme
        case fontSize
        case appearance
    }
}

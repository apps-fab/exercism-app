//
// Created by Kirk Agbenyegah on 01/10/2022.
//

import Foundation
import CodeEditor
import Combine

final class SettingsModel: ObservableObject, Codable {
    @Published var theme: CodeEditor.ThemeName
    @Published var fontSize: Double
    @Published var colorScheme: ExercismAppearance

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    init(theme: CodeEditor.ThemeName = CodeEditor.ThemeName.pojoaque,
         fontSize: Double = 12,
         colorScheme: ExercismAppearance = ExercismAppearance.dark) {
        self.theme = theme
        self.fontSize = fontSize
        self.colorScheme = colorScheme
    }

    var jsonData: Data? {
        get { try? encoder.encode(self)}
        set {
            guard let data = newValue, let model = try? decoder.decode(Self.self, from: data)
            else { return }
            theme = model.theme
            fontSize = model.fontSize
            colorScheme = model.colorScheme
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
        try container.encode(colorScheme, forKey: .colorScheme)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.theme = try container.decode(CodeEditor.ThemeName.self, forKey: .theme)
        self.fontSize = try container.decode(Double.self, forKey: .fontSize)
        self.colorScheme = try container.decode(ExercismAppearance.self, forKey: .colorScheme)
    }

    enum CodingKeys: String, CodingKey {
        case theme
        case fontSize
        case colorScheme
    }
}

//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation

struct ExerciseFile: Identifiable, Equatable {
    var id: String
    var type: ExerciseType
    var iconName = "doc.plaintext"
    var name: String
    var url: URL

    enum ExerciseType {
        case solution
        case test
    }

    init(url: URL, id: String, name: String, type: ExerciseType) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }

    static func fromURL(_ url: URL) -> ExerciseFile {
        ExerciseFile(url: url, id: url.relativeString, name: url.lastPathComponent, type: .solution)
    }
}

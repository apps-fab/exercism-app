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

    init(from url: URL) {
        self.url = url
        self.id = url.relativeString
        self.name = url.relativeString
        self.type = .solution
    }
}

extension ExerciseFile: Tabbable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(icon)
        hasher.combine(title)
    }

    var icon: String {
        self.iconName
    }

    var title: String {
        self.name
    }
}

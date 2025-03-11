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

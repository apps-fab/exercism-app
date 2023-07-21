//
// Created by Kirk Agbenyegah on 29/09/2022.
//

import Foundation
import ExercismSwift

struct ExerciseItem {
    var name: String
    var language: String
    var files: [ExerciseFile]
    
    init(name: String, language: String, files: [ExerciseFile]) {
        self.name = name
        self.language = language
        self.files = files
    }
}

//
//  Strings.swift
//  Exercism
//
//  Created by Angie Mugo on 18/07/2023.
//

import Foundation

enum Strings: String {
case new = "new"
case joined = "joined"
case exercises = "exercises"
case concepts = "concepts"
case learningMode = "learningMode"
case lastTouched = "lastTouched"
case searched = "searchLanguage"
case languageIntro = "languageIntro"
case languageNumber = "languageNumber"
case filterBy = "filterBy"
case showingTracks = "showingTracks"
case sortBy = "sortBy"
case joinedTracks = "joinedTracks"
case unjoinedTracks = "unjoinedTracks"
case all = "all"
case completedExercises = "CompletedExercises"
    case apply = "apply"
    case close = "close"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

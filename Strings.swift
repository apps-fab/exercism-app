//
//  Strings.swift
//  Exercism
//
//  Created by Angie Mugo on 18/07/2023.
//

import Foundation

enum Strings: String {
    case exercismText = "exercism"
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
    case loginText = "login"
    case completed = "completed"
    case inProgress = "inProgress"
    case learningExercise = "learningExercise"
    case locked = "locked"
    case submit = "submit"
    case runTests = "runTests"
    case runTestsBefore = "runTestsBefore"
    case toggleInstructions = "toggleInstructions"
    case solvedExercise = "solvedExercise"
    case submitCode = "submitCode"
    case errorDescription = "errorDescription"
    case taskCompleted =  "taskCompleted"
    case testFailed = "testFailed"
    case taskPass = "taskPass"
    case errorOccurred = "errorOccurred"
    case testsTimedOut = "testsTimedOut"
    case output = "output"
    case testNumber = "testNumber"
    case codeRun = "codeRun"
    case testFailure = "testFailure"
    case testError = "testError"
    case passed = "passed"
    case failed = "failed"
    case exerciseNumber = "exerciseNumber"
    case signOut = "signOut"
    case noResults = "noResults"
    case resetFilters =  "resetFilters"
    
    // login
    case loginError = "loginError"
    case loginIntroTitle = "introTitle"
    case loginIntroSubtitle = "intoSubtitle"
    case loginFreeText = "introFree"
    case loginCodePractice = "codePractice"
    case loginSettingsText = "settingsText"
    case loginImportantToken = "importantToken"
    case loginEnterToken = "enterToken"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

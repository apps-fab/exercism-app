//
//  Strings.swift
//  Exercism
//
//  Created by Angie Mugo on 18/07/2023.
//

import Foundation

enum Strings: String {
    case exercism = "Exercism"
    case login = "Log in"
    case new = "New"
    case joined = "Joined"
    case joinedTracks = "Joined Tracks"
    case unjoinedTracks = "Unjoined Tracks"
    case exercises = "%d Exercises"
    case concepts = "%d Concepts"
    case completedExercises = "%d/%d Exercises"
    case learningMode = "Learning Mode"
    case lastTouched = "Last touched %@ ago"
    case languageIntro = "Become fluent in your chosen programming languages by completing these tracks created by our [awesome team of contributors](https://exercism.org/contributing/contributors)"
    case languageNumber = "67+ languages for you to master"
    case searchLanguage = "Search language filters"
    case filterBy = "Filter by"
    case showingTracks = "Showing all %d tracks"
    case sortBy = "Sort by last touched"
    case all = "All Tracks"
    case apply = "Apply"
    case close = "Close"
    case submit = "Submit"
    case runTests = "Run Tests"
    case runTestsError = "You need to run the tests before submitting."
    case toggleInstructions = "Toggle instructions"

    case completed = "Completed"
    case inProgress = "In-progress"
    case learningExercise = "Learning Exercise"
    case locked = "Locked"
    case solvedExercise = "Sweet. Looks like you’ve solved the exercise!"
    case submitCode = "Good job! You can continue to improve your code or, if you're done, submit an iteration to  get automated feedback and optionally request mentoring."
    case errorDescription = " An error occurred while running your tests.%@ This might mean that there was an issue in Exercism infrastructure, or it might mean that you have something in your code that's causing our systems to break.%@ Please check your code, and if nothing seems to be wrong, try running the tests again."
    case taskCompleted = "%d/%d Tasks Completed"
    case testFailed = "Tests Failed"
    case taskPass = "All tasks passed"
    case testsTimedOut = "Your tests timed out"
    case output = "Your Output"
    case testNumber = "Test %d"
    case codeRun = "Code Run"
    case passed = "Passed"
    case failed = "Failed"
    case alert = "Alert"
    case exerciseNumber = "%d/%d exercises"
    case signOut = "Sign out"
    case noResults = "No results found"
    case resetFilters = "Reset search and filters"
    case publishCodeTitle = "Publish your code and share\nyour knowledge"
    case publishCodeSubtitle = "By publishing your code, you'll help others learn from your work.\nYou can choose which iterations you publish, add more iterations once it's published, and unpublish it at any time."
    case markAsComplete = "Mark as complete"

    // Login
    case introTitle = "Exercism is free for all people, everywhere."
    case introSubtitle = "Level up your programming skills over 5,521 exercises across 67+ languages, and insightful discussion with our dedicated team of welcoming mentors."
    case introFree = "Exercism is 100% free forever."
    case codePractice = "Code practice and mentorship for everyone"
    case enterToken = "Enter your token"
    case settingsText = "You can find your token on your [settings page](https://exercism.org/settings/api_cli)"
    case importantToken = "Important: The token above should be treated like a password and not be shared with anyone!"
    case instructions = "Instructions"
    case results = "Results"
    case runTestsTitle = "Run tests to check your code"
    case runTestsDescription = "We'll run your code against tests to check whether it works, then give you the results here."
    case runningTests = "Running tests..."
    case estimatedTime = "Estimated running time ~ %ds"
    case text = "Text"
    case noFile = "No file selected"
    case theme = "Theme"
    case submissionAlert = "Test submission"
    case ok = "OK"
    case correctSolution = "This solution correctly solves the latest version of this exercise."
    case wrongSolution = "This solution does not fully solve the latest version of this exercise"
    case solutionPublished = "Your solution has been published successfully."
    case solutionNotPublished = "Error publishing your solution. Try again later."
    case searchString = "Search by title"
    case searchTrackString = "Search language tracks"

    // Error strings
    case errorOccurred = "An error occurred"
    case loginError = "Error logging in"
    case testFailure = "Test Failure"
    case testError = "Test Error"
    case errorSubmitting = "Error submitting solution. Try again."
    case runFailed = "Test run failed. Try again."
    case tokenEmptyWarning = "API token cannot be empty"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//
//  ExerciseModelResponse.swift
//  Exercode
//
//  Created by Angie Mugo on 28/03/2025.
//

enum ExerciseModelResponse: Equatable {
    case solutionPassed, wrongSolution, runFailed, idle
    case solutionPublished
    case success(message: String)
    case genericError(error: String)

    var description: String {
        switch self {
        case .solutionPassed:
            return Strings.correctSolution.localized()
        case .wrongSolution:
            return Strings.wrongSolution.localized()
        case .runFailed:
            return Strings.runFailed.localized()
        case .idle:
            return ""
        case .solutionPublished:
            return Strings.solutionPublished.localized()
        case .success(let message):
            return message
        case .genericError(let error):
            return error
        }
    }
}

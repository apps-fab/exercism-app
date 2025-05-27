//
//  ExerciseModelResponse.swift
//  Exercode
//
//  Created by Angie Mugo on 28/03/2025.
//

import ExercismSwift

enum EditorActionState {
    case testRunSuccess(SubmissionLinks, TestRun)
    case getTestRunSuccess(Double)
    case actionErrored(String)
    case submitSuccess(String)
    case submitWrongSolution
    case solutionPublished
    case testInProgress(Double)
    case submitInProgress
    case submitError
    case revertSuccess
    case idle

    var description: String {
        switch self {
        case .actionErrored(let error):
            return error
        case .submitSuccess(let message):
            return message
        case .solutionPublished:
            return Strings.solutionPublished.localized()
        case .submitError:
            return Strings.submitError.localized()
        case .revertSuccess:
            return Strings.revertSuccess.localized()
        default:
            return ""
        }
    }
}

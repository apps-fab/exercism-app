//
//  AuthTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

final class AuthenticationViewModelTests: XCTestCase {

    @MainActor
    func test_validateToken_withEmptyInput_setsError() async {
        let viewModel = AuthenticationViewModel()

        await viewModel.validateToken()

        XCTAssertEqual(viewModel.error, Strings.tokenEmptyWarning.localized())
        XCTAssertTrue(viewModel.showAlert)
    }

    @MainActor
    func test_validateToken_withValidToken_setsAuthSuccess() async {
        let mockClient = MockExercismClient()
        mockClient.onValidateToken = { completion in
            let wrapper = ValidateTokenResponse.StatusWrapper(token: .valid)
            let response = ValidateTokenResponse(status: wrapper)
            completion(.success(response))
        }

        let viewModel = AuthenticationViewModel(clientFactory: { _ in mockClient })
        viewModel.tokenInput = "valid-token"
        await viewModel.validateToken()

        XCTAssertTrue(viewModel.authSuccess)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

    @MainActor
    func test_validateToken_withInvalidToken_setsError() async {
        let mockClient = MockExercismClient()
        let error = ExercismClientError.apiError(code: .invalidToken, type: "", message: "")

        mockClient.onValidateToken = { completion in
            completion(.failure(error))
        }

        let viewModel = AuthenticationViewModel(clientFactory: { _ in mockClient })

        viewModel.tokenInput = "invalid_token"
        await viewModel.validateToken()

        XCTAssertEqual(viewModel.error, error.description)
        XCTAssertFalse(viewModel.authSuccess)
    }
}

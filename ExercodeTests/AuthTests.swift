//
//  AuthTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    private var client: MockExercismClient!
    private var viewModel: AuthenticationViewModel!

    override func tearDown() async throws {
        viewModel = nil
        client = nil
    }

    override func setUp() async throws {
        client = MockExercismClient()
        viewModel = AuthenticationViewModel(clientFactory: { _ in self.client })
    }

    func testEmptyString() async {
        await viewModel.validateToken()

        XCTAssertEqual(viewModel.error, Strings.tokenEmptyWarning.localized())
        XCTAssertTrue(viewModel.showAlert)
    }

    func testAuthSuccess() async {
        client.onValidateToken = {
            let wrapper = ValidateTokenResponse.StatusWrapper(token: .valid)
            return ValidateTokenResponse(status: wrapper)
        }

        viewModel.tokenInput = "valid-token"
        await viewModel.validateToken()

        XCTAssertTrue(viewModel.authSuccess)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

    func testInvalidToken() async {
        let error = ExercismClientError.apiError(code: .invalidToken, type: "", message: "")

        client.onValidateToken = { () throws(ExercismClientError) in
            throw error
        }

        viewModel.tokenInput = "invalid token"
        await viewModel.validateToken()

        XCTAssertEqual(viewModel.error, error.description)
        XCTAssertFalse(viewModel.authSuccess)
    }
}

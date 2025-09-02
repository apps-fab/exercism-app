//
//  AuthenticationViewModel.swift
//  Exercism
//
//  Created by Cédric Bahirwe on 06/11/2023.
//

import Foundation
import ExercismSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    private let clientFactory: (String) -> ExercismClientType

    init(clientFactory: @escaping (String) -> ExercismClientType = { ExercismClient(apiToken: $0) }) {
        self.clientFactory = clientFactory
    }

    @Published var tokenInput = ""
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var authSuccess = false
    @Published var error: String? {
        didSet {
            showAlert = true
        }
    }

    func validateToken() async {
        guard !tokenInput.isEmpty else {
            error = Strings.tokenEmptyWarning.localized()
            return
        }

        isLoading = true
        do {
            _ = try await performAsyncTokenValidation(token: tokenInput)
            isLoading = false
            authSuccess = true
        } catch {
            isLoading = false
            self.error = error.description
        }
    }

    private func performAsyncTokenValidation(token: String) async throws(ExercismClientError) -> ValidateTokenResponse {
        let client = clientFactory(token)
        return try await client.validateToken()
    }
}

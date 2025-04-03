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
    @Published var tokenInput = ""
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var error: String? {
        didSet {
            showAlert = true
        }
    }

    func validateToken() async -> Bool {
        guard !tokenInput.isEmpty else {
            error = Strings.tokenEmptyWarning.localized()
            showAlert = true
            return false
        }
        isLoading = true

        do {
            let isValid = try await performAsyncTokenValidation(token: tokenInput)
            self.isLoading = false
            return isValid
        } catch let appError as ExercismClientError {
            self.isLoading = false
            error = appError.description
            return false
        } catch {
            self.isLoading = false
            self.error = ExercismClientError.unsupportedResponseError.description
            return false
        }
    }

    private func performAsyncTokenValidation(token: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let client = ExercismClient(apiToken: token)
            client.validateToken { response in
                switch response {
                case .success:
                    continuation.resume(returning: true)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

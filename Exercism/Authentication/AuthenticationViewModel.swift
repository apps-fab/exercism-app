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
            showAlert = true
            return
        }

        isLoading = true
        do {
            try await performAsyncTokenValidation(token: tokenInput)
            isLoading = false
            authSuccess = true
        } catch let appError as ExercismClientError {
            isLoading = false
            error = appError.description
        } catch {
            isLoading = false
            self.error = ExercismClientError.unsupportedResponseError.description
        }
    }

    private func performAsyncTokenValidation(token: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let client = clientFactory(token)
            client.validateToken { response in
                switch response {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

//
//  AuthenticationViewModel.swift
//  Exercism
//
//  Created by Cédric Bahirwe on 06/11/2023.
//

import Foundation
import ExercismSwift

final class AuthenticationViewModel: ObservableObject {
    @Published var tokenInput = ""
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var error: String?
    
    @MainActor
    func validateToken() async -> Bool {
        guard !tokenInput.isEmpty else {
            error = "API token cannot be empty"
            showAlert = true
            return false
        }
        isLoading = true
        
        do {
            let isValid = try await performAsyncValidation(tokenInput)
            self.isLoading = false
            return isValid
        } catch {
            self.isLoading = false
            
            if case let ExercismClientError.apiError(_, _, message) = error {
                self.error = message
            } else {
                self.error = "Unknown error"
            }

            showAlert = true
            return false
        }
        
    }
    
    private func performAsyncValidation(_ token: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            let client = ExercismClient(apiToken: token)
            client.validateToken { response in
                switch response {
                case .success(_):
                    continuation.resume(returning: true)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

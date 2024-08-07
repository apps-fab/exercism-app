//
//  KeychainHelper.swift
//  Exercism
//
//  Created by Angie Mugo on 29/09/2022.
//

@preconcurrency import KeychainSwift

final class ExercismKeychain: Sendable {
   public static let shared = ExercismKeychain()
    private let keychain = KeychainSwift()

    func set(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }

    func get(for key: String) -> String? {
        keychain.get(key)
    }

    func removeItem(for key: String) {
        keychain.delete(key)
    }
}

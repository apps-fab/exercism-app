//
//  KeychainHelper.swift
//  Exercism
//
//  Created by Angie Mugo on 29/09/2022.
//

@preconcurrency import KeychainAccess

final class ExercismKeychain: Sendable {
    public static let shared = ExercismKeychain()
    private let keychain: Keychain

    init() {
        keychain = Keychain()
            .synchronizable(true)
    }

    func set(_ value: String, for key: String) {
        do {
            try keychain.set(value, key: key)
        } catch let error {
            print("Error setting keychain item: \(error)")
        }
    }

    func get(for key: String) -> String? {
        do {
            return try keychain.get(key)
        } catch {
            print("Error setting keychain item: \(error)")
            return nil
        }
    }

    func removeItem(for key: String) {
        do {
            try keychain.remove(key)
        } catch let error {
            print("error: \(error)")
        }
    }
}

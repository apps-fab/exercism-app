//
//  StreakPersistence.swift
//  Exercode
//
//  Created by Angie Mugo on 10/06/2025.
//

import Foundation

extension FileManager: StreakPersistence {
    private var key: String {
        StreakOptions.shared.key
    }

    func getData() -> Data? {
        guard let documents = getDocumentsDirectory() else { return nil }
        let file = documents.appendingPathComponent(key)
        return try? Data(contentsOf: file)
    }

    func save<T: Codable>(data: T) throws {
        guard let documents = getDocumentsDirectory() else { throw FileError.failedToFetchDocuments }
        let file = documents.appendingPathComponent(key)
        let fileData = try JSONEncoder().encode(data)
        try fileData.write(to: file, options: [.atomic])
    }

    func getDocumentsDirectory() -> URL? {
        return urls(for: .documentDirectory, in: .userDomainMask).first
    }

    enum FileError: Error {
        case failedToFetchDocuments
    }
}

protocol StreakPersistence {
    func getData() -> Data?
    func save(data: Data) throws
}

enum StreakPersistenceType {
    case userDefaults
    case sharedUserDefaults(appGroup: String)
    case documentsDirectory
    case custom(any StreakPersistence)

    func makePersistence() -> StreakPersistence {
        switch self {
        case .userDefaults:
            return UserDefaults.standard
        case .sharedUserDefaults(let appGroup):
            if let shared = UserDefaults(suiteName: appGroup) {
                return shared
            } else {
                print("Unable to create shared userdefaults, defaulting to standard")
                return UserDefaults.standard
            }
        case .documentsDirectory:
            return FileManager.default
        case .custom(let persistence):
            return persistence
        }
    }
}

extension UserDefaults: StreakPersistence {

    private var key: String {
        StreakOptions.shared.key
    }

    public func getData() -> Data? {
        data(forKey: key)
    }

    public func save(data: Data) throws {
        set(data, forKey: key)
    }
}

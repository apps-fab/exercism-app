//
//  AppCoordinator.swift
//  Exercism
//
//  Created by Angie Mugo on 23/11/2022.
//

import Foundation
import SwiftUI
import ExercismSwift
import Combine

enum Route: Hashable, Identifiable, Codable {
    var id: Self { return self }

    case Track(Track)
    case Exercise(String, String, Solution?)
    case Login
    case Dashboard
}

final class NavigationModel: ObservableObject, Codable {
    @Published var path: [Route]
    @Published var columnVisibility: NavigationSplitViewVisibility

    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()

    
    init(path: [Route] = [], columnVisibility: NavigationSplitViewVisibility = .automatic) {
        self.columnVisibility = columnVisibility
        self.path = path
    }
    
    var jsonData: Data? {
        get { try? encoder.encode(self) }
        set {
            guard let data = newValue, let model = try? decoder.decode(Self.self, from: data)
            else { return }
            path = model.path
            columnVisibility = model.columnVisibility
        }
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedPath = try container.decode([Route].self, forKey: .path)
        self.path = decodedPath
        
        self.columnVisibility = try container.decode(NavigationSplitViewVisibility.self, forKey: .columnVisibility)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(path, forKey: .path)
        try container.encode(columnVisibility, forKey: .columnVisibility)
    }

    func goToDashboard() {
        path.append(Route.Dashboard)
    }
    
    func goToTrack(_ track: Track) {
        path.append(Route.Track(track))
    }
    
    func goToEditor(_ track: String, _ exercise: Exercise, solution: Solution?) {
        guard exercise.isUnlocked else { return }
        path.append(Route.Exercise(track, exercise.slug, solution))
    }
    
    func goToLogin() {
        path.removeAll()
        path.append(Route.Login)
    }

    enum CodingKeys: String, CodingKey {
        case path
        case columnVisibility
    }
}

extension DispatchQueue {
    static let pathMutatingLock = DispatchQueue(label: "person.lock.queue")
}

//
//  AppCoordinator.swift
//  Exercism
//
//  Created by Angie Mugo on 23/11/2022.
//

import Foundation
import SwiftUI
import ExercismSwift

enum Route: Hashable {
    case Track(Track)
    case Exercise(String, String)
    case Dashboard
}

class AppCoordinator: ObservableObject {
    @Published var path = [Route]()

    func goToDashboard() {
        path.append(Route.Dashboard)
    }

    func goToTrack(_ track: Track) {
        path.append(Route.Track(track))
    }

    func goToEditor(_ track: String, _ exercise: String) {
        path.append(Route.Exercise(track, exercise))
    }

    func goBack() {
        path.removeLast()
    }
}

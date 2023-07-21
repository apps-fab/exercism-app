//
//  AppCoordinator.swift
//  Exercism
//
//  Created by Angie Mugo on 23/11/2022.
//

import Foundation
import SwiftUI
import ExercismSwift

enum Route: Hashable, Identifiable {
    var id: Self { return self }
    
    case Track(Track)
    case Exercise(String, String)
    case Login
    case Dashboard
}

class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    init() {
        if let _ = ExercismKeychain.shared.get(for: "token") {
            path.append(Route.Dashboard)
        } else {
            path.append(Route.Login)
        }
    }
    
    func goToDashboard() {
        path.append(Route.Dashboard)
    }
    
    func goToTrack(_ track: Track) {
        path.append(Route.Track(track))
    }
    
    func goToEditor(_ track: String, _ exercise: String) {
        path.append(Route.Exercise(track, exercise))
    }
    
    func goToLogin() {
        path.append(Route.Login)
    }
}

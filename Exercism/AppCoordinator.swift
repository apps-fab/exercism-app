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
    case Login
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

    func goToLogin() {
        path.append(Route.Login)
    }

    func goBack() {
        path.removeLast()
    }
}

struct Coordinator: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            NavigationView {
                EmptyView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case let .Exercise(track, exercise):
                            ExerciseEditorWindowView(coordinator: coordinator, exercise: exercise, track: track)

                        case let .Track(track):
                            ExercisesList(coordinator: coordinator, track: track)

                        case .Login:
                            LoginView(coordinator: coordinator)

                        case .Dashboard:
                            DashBoard(coordinator: coordinator)
                        }
                    }
            }.onAppear {
                if let _ = ExercismKeychain.shared.get(for: "token") {
                    coordinator.goToDashboard()
                } else {
                    coordinator.goToLogin()
                }
            }
        }
    }
}

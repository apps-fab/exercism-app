//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        return NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .Exercise(track, exercise):
                        ExerciseEditorWindowView(exercise: exercise, track: track)                .environmentObject(coordinator)

                        
                    case let .Track(track):
                        ExercisesList(track: track).environmentObject(coordinator)

                        
                    case .Login:
                        LoginView().environmentObject(coordinator)

                        
                    case .Dashboard:
                        Dashboard().frame(minWidth: 800, minHeight: 800)                .environmentObject(coordinator)

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

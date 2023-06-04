//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        return NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .Exercise(track, exercise):
                        ExerciseEditorWindowView(exercise: exercise, track: track)
                        
                    case let .Track(track):
                        ExercisesList(coordinator: coordinator, track: track)
                        
                    case .Login:
                        LoginView(coordinator: coordinator)
                        
                    case .Dashboard:
                        Dashboard(coordinator: coordinator).frame(minWidth: 800, minHeight: 800)
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

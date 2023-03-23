//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
            NavigationSplitView {
                SideBar().frame(minWidth: 266)
            } detail: {
                NavigationStack(path: $coordinator.path) {
                    NavigationView {
                        EmptyView()
                    }
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case let .Exercise(track, exercise):
                            ExerciseEditorWindowView(coordinator: coordinator, exercise: exercise, track: track)

                        case let .Track(track):
                            ExercisesList(track: track)

                        case .Login:
                            LoginView()

                        case .Dashboard:
                            TracksListView()
                        }
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

//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationModel = NavigationModel()
    @SceneStorage("navigation") private var navigationData: Data?

    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            ZStack {
                if ExercismKeychain.shared.get(for: Keys.token.rawValue) == nil {
                    LoginView()
                }
            }
            .environmentObject(navigationModel)
            .task {
                await performInitialNavigationSetup()
            }
            .navigationDestination(for: Route.self, destination: handleDestinationRoute)
            .navigationBarBackButtonHidden(false)
        }
        .frame(
            minWidth: 800, idealWidth: 1000, maxWidth: .infinity,
            minHeight: 500, idealHeight: 800, maxHeight: .infinity
        )
    }

    private func performInitialNavigationSetup() async {
        if let navigationData {
            navigationModel.jsonData = navigationData
        }

        // User is logged in but navigationModel path is empty
        if ExercismKeychain.shared.get(for: Keys.token.rawValue) != nil && navigationModel.path.isEmpty {
            navigationModel.goToDashboard()
            // Save navigation data into scene storage
            navigationData = navigationModel.jsonData
        }

        for await _ in navigationModel.objectWillChangeSequence {
            navigationData = navigationModel.jsonData
        }
    }

    @ViewBuilder
    private func handleDestinationRoute(_ route: Route) -> some View {
        switch route {
        case let .exercise(track, exercise, solution):
            ExerciseEditorWindowView(track, exercise, solution)
                .environmentObject(navigationModel)

        case let .track(track):
            ExercisesList(track: track)
                .environmentObject(navigationModel)

        case .login:
            LoginView()
                .environmentObject(navigationModel)

        case .dashboard:
            TracksListView()
                .environmentObject(navigationModel)
        }
    }
}

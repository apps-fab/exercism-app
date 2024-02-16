//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI

enum Design {
    enum Login {
        static let minSize = CGSizeMake(800, 500)
    }
}
struct ContentView: View {
    @StateObject private var navigationModel = NavigationModel()
    @SceneStorage("navigation") private var navigationData: Data?
    private let model = TrackModel.shared
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            Group {
                if let _ = ExercismKeychain.shared.get(for: Keys.token.rawValue) {
                    TracksListView(
                        asyncModel: .init { try await model.getTracks() }
                    )
                    .environmentObject(navigationModel)
                } else {
                    LoginView()
                }
            }
            .environmentObject(navigationModel)
            .task(performInitialNavigationSetup)
            .navigationDestination(for: Route.self, destination: handleDestinationRoute)
        }
        .frame(
            minWidth: 800, idealWidth: 1000, maxWidth: .infinity,
            minHeight: 500, idealHeight: 800, maxHeight: .infinity
        )
    }
    
    @Sendable
    private func performInitialNavigationSetup() async {
        if let navigationData {
            navigationModel.jsonData = navigationData
        }
        
        for await _ in navigationModel.objectWillChangeSequence {
            navigationData = navigationModel.jsonData
        }
    }
    
    @ViewBuilder
    private func handleDestinationRoute(_ route: Route) -> some View {
        switch route {
        case let .Exercise(track, exercise, solution):
            ExerciseEditorWindowView(asyncModel: AsyncModel(operation: { try await ExerciseViewModel.shared.getDocument(track, exercise) } ), solution: solution)
                .environmentObject(navigationModel)
            
        case let .Track(track):
            ExercisesList(track: track,
                          asyncModel: .init { try await model.getExercises(track) })
            .environmentObject(navigationModel)
            
        case .Login:
            LoginView()
                .environmentObject(navigationModel)
            
        case .Dashboard:
            TracksListView(asyncModel: .init { try await model.getTracks() })
                .environmentObject(navigationModel)
        }
    }
}

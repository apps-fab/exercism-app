//
//  ContentView.swift
//  Exercism
//
//  Created by Angie Mugo on 16/03/2023.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        let token = ExercismKeychain.shared.get(for: "token")
        let client = ExercismClient(apiToken: token ?? "")
        let fetcher = Fetcher(client: client)
        
        return NavigationStack(path: $coordinator.path) {
            EmptyView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .Exercise(track, exercise):
                        ExerciseEditorWindowView(exercise: exercise, track: track)

                    case let .Track(track):
                        ExercisesList(track: track)

                    case .Login:
                        LoginView()

                    case .Dashboard:
                        Dashboard().frame(minWidth: 800, minHeight: 800)
                    }
                }
        }.onAppear {
            if let _ = ExercismKeychain.shared.get(for: "token") {
                coordinator.goToDashboard()
            } else {
                coordinator.goToLogin()
            }
        }.environmentObject(SettingData())
            .environmentObject(coordinator)
            .environmentObject(TrackModel(fetcher: fetcher))
    }
}

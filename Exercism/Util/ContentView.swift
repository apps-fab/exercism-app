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
        let token = ExercismKeychain.shared.get(for: "token")
        let client = ExercismClient(apiToken: token ?? "")
        let fetcher = Fetcher(client: client)
        return NavigationStack(path: $coordinator.path) {
            NavigationView {
                if let _ = ExercismKeychain.shared.get(for: "token") {
                    dashboard()
                } else {
                    LoginView()
                }
            }.navigationDestination(for: Route.self) { route in
                switch route {
                case let .Exercise(track, exercise):
                    ExerciseEditorWindowView(coordinator: coordinator, exercise: exercise, track: track)
                    
                case let .Track(track):
                    ExercisesList(track: track)
                    
                case .Login:
                    LoginView()
                    
                case .TracksList:
                    dashboard()
                }
            }
        }.environmentObject(coordinator)
            .environmentObject(TrackModel(fetcher: fetcher,
                                          coordinator: coordinator))
    }

    func dashboard() -> some View {
        return NavigationSplitView {
            SideBar().frame(minWidth: 300)
        } detail: {
            TracksListView()
        }
    }
}

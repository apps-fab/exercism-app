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
    @EnvironmentObject var model: TrackModel
    
    var body: some View {
        return NavigationStack(path: $coordinator.path) {
            EmptyView().environmentObject(coordinator)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .Exercise(track, exercise):
                        ExerciseEditorWindowView(exercise: exercise,
                                                 track: track)
                        .environmentObject(coordinator)
                        
                        
                    case let .Track(track):
                        ExercisesList(track: track,
                                      asyncModel: AsyncModel(operation: { try await model.getExercises(track) }))
                        .environmentObject(coordinator)
                        
                    case .Login:
                        LoginView()
                            .environmentObject(coordinator)
                        
                        
                    case .Dashboard:
                        Dashboard(asyncModel: AsyncModel(operation: { try await model.getTracks()} ))
                            .frame(minWidth: 800, minHeight: 800)
                            .environmentObject(coordinator)
                    }
                }
        }
    }
}

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
    let model = TrackModel.shared

    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            Group {
                if let _ = ExercismKeychain.shared.get(for: Keys.token.rawValue) {
                    TracksListView(asyncModel: AsyncModel(operation: { try await model.getTracks()} ))
                        .frame(minWidth: 800, minHeight: 800)
                        .environmentObject(navigationModel)

                } else {
                    LoginView().frame(minWidth: 800, minHeight: 800)
                }
            }.environmentObject(navigationModel)
                .task {
                    if let jsonData = navigationData {
                        navigationModel.jsonData = jsonData
                    }
                    
                    for await _ in navigationModel.objectWillChangeSequence {
                        navigationData = navigationModel.jsonData
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .Exercise(track, exercise):
                        ExerciseEditorWindowView(asyncModel: AsyncModel(operation: { try await ExerciseViewModel.shared.getDocument(track, exercise) } ))
                        .environmentObject(navigationModel)

                    case let .Track(track):
                        ExercisesList(track: track,
                                      asyncModel: AsyncModel(operation: { try await model.getExercises(track) }))
                        .environmentObject(navigationModel)

                    case .Login:
                        LoginView()
                            .environmentObject(navigationModel)

                    case .Dashboard:
                        TracksListView(asyncModel: AsyncModel(operation: { try await model.getTracks()} ))
                            .frame(minWidth: 800, minHeight: 800)
                            .environmentObject(navigationModel)
                    }
                }
        }

        }
    }

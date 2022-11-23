//
//  DashBoard.swift
//  Exercism
//
//  Created by Angie Mugo on 22/09/2022.
//

import SwiftUI
import ExercismSwift

enum ItemType: String {
    case recentTrack = "Tracks"
    case profile = "Profile Items"
}

struct DashboardItem: Identifiable {
    let name: String
    let image = "folder.fill"
    let id = UUID()
}

struct DashboardSections: Identifiable {
    let type: ItemType
    let items: [DashboardItem]
    let id = UUID()
}

struct DashBoard: View {
    @State var searchText: String = ""
    @StateObject private var coordinator = AppCoordinator()
    
    
    // To Do: Get the actual recent tracks and the profile items to be shown
    private var itemNames = [DashboardSections(type: .profile, items: [DashboardItem(name: "All tracks"),
                                                                       DashboardItem(name: "Solutions"),
                                                                       DashboardItem(name: "Badges")]),
                             DashboardSections(type: .recentTrack, items:  [DashboardItem(name: "Elixir"),
                                                                            DashboardItem(name: "Rust")])]
    
    var body: some View {
        NavigationSplitView {
            List() {
                ForEach(itemNames) { name in
                    Section(header: Text(name.type.rawValue)) {
                        ForEach(name.items) { item in
                            HStack {
                                Image(systemName: item.image)
                                    .renderingMode(.template)
                                    .foregroundColor(.blue)
                                Text(item.name)
                            }
                        }
                    }
                }
            }.accessibilityLabel("The dashboard")
                .frame(minWidth: 200)
        } detail: {
            NavigationStack(path: $coordinator.path) {
                TracksView(coordinator: coordinator)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case let .Exercise(exercise):
                            ExerciseEditorWindowView()

                        case let .Track(track):
                            ExercisesList(viewModel: ExerciseListViewModel(trackName: track.slug))

                        case .Dashboard:
                            LoginView()
                        }
                    }
            }
        }
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoard()
    }
}

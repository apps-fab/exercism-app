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
    let image: String
    let id = UUID()
}

struct DashboardSections: Identifiable {
    let type: ItemType
    let items: [DashboardItem]
    let id = UUID()
}

// To Do: Get the actual recent tracks and the profile items to be shown
var itemNames = [DashboardSections(type: .profile, items: [DashboardItem(name: "All tracks", image: "folder.fill"),
                                                           DashboardItem(name: "Solutions", image: "folder.fill"),
                                                           DashboardItem(name: "Badges", image: "folder.fill"),
                                                           DashboardItem(name: "Log Out", image: "person.fill")]),
                 DashboardSections(type: .recentTrack, items:  [DashboardItem(name: "Elixir", image: "folder.fill"),
                                                                DashboardItem(name: "Rust", image: "folder.fill")])]

struct DashBoard: View {
    @State var searchText: String = ""
    @StateObject var coordinator: AppCoordinator

    var body: some View {
        NavigationSplitView {
            List() {
                ForEach(itemNames) { name in
                    Section(header: Text(name.type.rawValue)) {
                        ForEach(name.items) { item in
                            Button {
                                if item.name == "Log Out" {
                                    self.logout()
                                }
                            } label: {
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
            }
        } detail: {
            TracksView(viewModel: TracksViewModel(coordinator: coordinator))
        }
    }

    func logout() {
        DispatchQueue.global().async {
            ExercismKeychain.shared.removeItem(for: Keys.token.rawValue)
        }
        coordinator.goToLogin()
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoard(coordinator: AppCoordinator())
    }
}

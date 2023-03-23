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
    @State var showProfile = false
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        TracksListView()
            .toolbar {
                ToolbarItemGroup {
                    Spacer()
                    Button {
                        showProfile.toggle()
                    } label: {
                        Label("", systemImage: "person.crop.circle.fill")
                    }   .popover(isPresented: $showProfile) {
                        ProfileTableView().frame(width: 180, height: 200)
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

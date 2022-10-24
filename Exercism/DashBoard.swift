//
//  DashBoard.swift
//  Exercism
//
//  Created by Angie Mugo on 22/09/2022.
//

import SwiftUI

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

    private var itemNames = [DashboardSections(type: .profile, items: [DashboardItem(name: "All tracks"),
                                                                       DashboardItem(name: "Solutions"),
                                                                       DashboardItem(name: "Badges")]),
                             DashboardSections(type: .recentTrack, items:  [DashboardItem(name: "Elixir"),
                                                                            DashboardItem(name: "Rust")])]

    var body: some View {
        NavigationView {
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
            }.frame(minWidth: 200)
            TracksView()
        }.frame(minHeight: 600, maxHeight: .infinity)
            .frame(minWidth: 600, maxWidth: .infinity)
    }
}

struct DashBoard_Previews: PreviewProvider {
    static var previews: some View {
        DashBoard()
    }
}

//
//  Dashboard.swift
//  Exercism
//
//  Created by Angie Mugo on 08/04/2023.
//

import SwiftUI

struct Dashboard: View {
    @State var coordinator: AppCoordinator

    var body: some View {
        NavigationSplitView {
            SideBar(coordinator: coordinator).frame(minWidth: 200)
        } detail: {
            TracksListView(coordinator: coordinator)
        }
    }
}

//
//  Dashboard.swift
//  Exercism
//
//  Created by Angie Mugo on 08/04/2023.
//

import SwiftUI
import ExercismSwift

struct Dashboard: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State var asyncModel: AsyncModel<[Track]>

    var body: some View {
        NavigationSplitView {
            SideBar().frame(minWidth: 200)
        } detail: {
            TracksListView(asyncModel: asyncModel)
        }
    }
}

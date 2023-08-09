//
//  Dashboard.swift
//  Exercism
//
//  Created by Angie Mugo on 08/04/2023.
//

import SwiftUI
import ExercismSwift

struct Dashboard: View {
    @State var asyncModel: AsyncModel<[Track]>
    @EnvironmentObject private var navigationModel: NavigationModel
    let model = TrackModel.shared

    var body: some View {
        HStack {
            SideBar().frame(maxWidth: 200)
            Divider()
            TracksListView(asyncModel: asyncModel)
        }
    }
}

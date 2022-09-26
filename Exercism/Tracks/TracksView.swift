//
//  TracksView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI

struct TracksView: View {
    @ObservedObject var viewModel = TracksViewModel()
    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        GeometryReader { geometryReader in
            ScrollView {
                LazyVGrid(columns: rows, spacing: 20) {
                    ForEach(viewModel.tracks) { track in
                        TrackGridView(track: track)
                    }
                }.onAppear(perform: viewModel.fetchTracks)
            }
        }
    }
}

struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksView()
    }
}

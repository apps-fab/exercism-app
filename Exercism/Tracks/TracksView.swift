//
//  TracksView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI

struct TracksView: View {
    @ObservedObject var viewModel = TracksViewModel()
    @State private var searchText = ""

    let rows = [
        GridItem(.fixed(600)),
        GridItem(.fixed(600))
    ]

    var body: some View {
            ScrollView {
                LazyVStack {
                    Text("61 languages for you to master")
                    Text("Become fluent in your chosen programming languages by completing these tracks created by our [awesome team of contributors](https://exercism.org/contributing/contributors)")
                    LazyVGrid(columns: rows) {
                        ForEach(viewModel.joinedTracks) { track in
                            TrackGridView(track: track)
                        }
                    }
                    LazyVGrid(columns: rows) {
                        ForEach(viewModel.unJoinedTracks) { track in
                            TrackGridView(track: track)
                        }
                    }
                }.onAppear(perform: viewModel.fetchTracks)
            }
    }
}

struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksView()
    }
}

//
//  TracksView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TracksView: View {
    @StateObject var viewModel = TracksViewModel()
    @State private var searchText = ""
    @State private var filters = Set<String>()
    var coordinator: AppCoordinator

    let rows = [
        GridItem(.fixed(600)),
        GridItem(.fixed(600))
    ]

    var body: some View {
        ScrollView {
            VStack {
                FilterView(searchText: $searchText,
                           filters: $filters).padding()

                LazyVGrid(columns: rows) {
                    ForEach(viewModel.joinedTracks) { track in
                        TrackGridView(track: track).accessibilityElement(children: .contain)
                            .onTapGesture {
                                coordinator.goToTrack(track)
                            }
                    }
                }.accessibilityLabel("Joined Tracks")
                LazyVGrid(columns: rows) {
                    ForEach(viewModel.unJoinedTracks) { track in
                        TrackGridView(track: track).accessibilityElement(children: .contain)
                    }
                }.accessibilityLabel("Unjoined tracks")
            }.accessibilityHidden(true)
        }.accessibilityLabel("All Tracks")
            .task {
                viewModel.fetchTracks()
            }.onChange(of: searchText) { newSearch in
                viewModel.search(newSearch)
            }.onChange(of: filters) { newFilters in
                viewModel.filter(newFilters)
            }
    }
}


struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksView(coordinator: AppCoordinator())
    }
}

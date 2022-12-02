//
//  TracksView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TracksView: View {
    @StateObject var viewModel: TracksViewModel
    @State private var resultsCount = 0
    @State private var searchText = ""
    @State private var filters = Set<String>()

    let columns = [
        GridItem(.fixed(600)),
        GridItem(.fixed(600))
    ]

    var body: some View {
        ScrollView {
            VStack {
                FilterView(results: $resultsCount,
                           searchText: $searchText,
                           filters: $filters) {
                    viewModel.filteredTracks.sort { $0.lastTouchedAt ?? Date() < $1.lastTouchedAt ?? Date() }
                }
                           .padding()

                LazyVGrid(columns: columns) {
                    ForEach(viewModel.joinedTracks) { track in
                        Button {
                            viewModel.goToExercises(track)
                        } label: {
                            TrackGridView(track: track).accessibilityElement(children: .contain)
                        }.buttonStyle(.plain)
                    }
                    Spacer()
                    ForEach(viewModel.unJoinedTracks) { track in
                        Button {
                            viewModel.goToExercises(track)
                        } label: {
                            TrackGridView(track: track).accessibilityElement(children: .contain)
                        }.buttonStyle(.plain)
                    }
                }.accessibilityHidden(true)
            }.accessibilityLabel("All Tracks")
                .task {
                    viewModel.fetchTracks()
                    resultsCount = viewModel.tracks.count
                }.onChange(of: searchText) { newSearch in
                    viewModel.search(newSearch)
                    resultsCount = viewModel.filteredTracks.count
                }.onChange(of: filters) { newFilters in
                    viewModel.filter(newFilters)
                    resultsCount = viewModel.filteredTracks.count
                }
        }
    }
}


struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksView(viewModel: TracksViewModel(coordinator: AppCoordinator()))
    }
}

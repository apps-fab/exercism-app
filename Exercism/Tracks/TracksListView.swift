//
//  TracksListView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TracksListView: View {
    @StateObject var viewModel: TracksViewModel
    @State private var resultsCount = 0
    @State private var searchText = ""
    @State private var filters = Set<String>()

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]

    var body: some View {
        switch viewModel.state {
        case .Idle:
            Color.clear.onAppear(perform: viewModel.fetchTracks)
        case .Loaded(let tracks):
            VStack {
                VStack {
                    headerView
                        .background(.black)
                        .frame(maxWidth: 650, maxHeight: 160)
                        .padding()
                    Divider().frame(height: 1)
                    FilterView(results: $resultsCount,
                               searchText: $searchText,
                               filters: $filters) {
                        viewModel.sort()
                    }.frame(maxHeight: 50)
                        .padding()
                    Divider().frame(height: 1)
                }.background(.black)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Joined Tracks")
                            .font(.largeTitle)
                            .padding()
                        LazyVGrid(columns: columns) {
                            ForEach(tracks.joinedTracks) { track in
                                Button {
                                    viewModel.goToExercises(track)
                                } label: {
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }.buttonStyle(.plain)
                            }
                        }

                        Text("Unjoined Tracks")
                            .font(.largeTitle)
                            .padding()
                        LazyVGrid(columns: columns) {
                            ForEach(tracks.unjoinedTracks) { track in
                                Button {
                                    viewModel.goToExercises(track)
                                } label: {
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding()
                        .accessibilityHidden(true)
                }
            }.accessibilityLabel("All Tracks")
             .onChange(of: searchText) { newSearch in
                    viewModel.search(newSearch)
                 resultsCount = tracks.joinedTracks.count + tracks.unjoinedTracks.count
                }.onChange(of: filters) { newFilters in
                    viewModel.filter(newFilters)
                    resultsCount = tracks.joinedTracks.count + tracks.unjoinedTracks.count
                }
        case .loading:
            ProgressView()
        case .Error(let error):
            EmptyView()
        }
    }

    var headerView: some View {
        VStack(alignment: .center) {
            Image("trackImages")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 170)
            Text("66 languages for you to master").font(.largeTitle)
            Text("Become fluent in your chosen programming languages by completing these tracks created by our awesome team of contributors")
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}


struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksListView(viewModel: TracksViewModel(coordinator: AppCoordinator()))
    }
}

//
//  TracksListView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TracksListView: View {
    @EnvironmentObject private var model: TrackModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var searchText = ""
    @State private var filters = Set<String>()
    @State var asyncModel: AsyncModel<[Track]>

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]

    var body: some View {
        AsyncResultView(source: asyncModel) { tracks in
            tracksView(tracks)
        }.accessibilityLabel("All Tracks")
            .onChange(of: searchText) { newSearch in
                asyncModel.filterOperations = { self.model.filterTracks(newSearch) }
            }.onChange(of: filters) { newFilters in
                print(newFilters.count)
                asyncModel.filterOperations = { self.model.filterTags(newFilters) }
            }
    }

    @ViewBuilder
    func tracksView(_ tracks: [Track]) ->  some View {
        let joined = tracks.filter { $0.isJoined }
        let unjoined = tracks.filter { !$0.isJoined }

        VStack {
            VStack {
                headerView
                    .background(Color("darkBackground"))
                    .frame(maxWidth: 650, maxHeight: 160)
                    .padding()
                Divider().frame(height: 1)
                FilterView(results: tracks.count,
                           searchText: $searchText,
                           filters: $filters) {
                    asyncModel.filterOperations = { self.model.sortTracks() }
                }.frame(maxHeight: 50)
                    .padding()
                Divider().frame(height: 1)
            }.background(Color("darkBackground"))
            ScrollView {
                VStack(alignment: .leading) {
                        Text("Joined Tracks")
                            .font(.largeTitle)
                            .padding()
                            .if(joined.isEmpty) { text in
                                text.hidden()
                            }
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(joined) { track in
                                Button {
                                    coordinator.goToTrack(track)
                                } label: {
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }.buttonStyle(.plain)
                            }
                    }

                        Text("Unjoined Tracks")
                            .font(.largeTitle)
                            .padding()
                            .if(unjoined.isEmpty) { text in
                                text.hidden()
                            }
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(unjoined) { track in
                                Button {
                                    coordinator.goToTrack(track)
                                } label: {
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }.buttonStyle(.plain)
                            }
                    }
                }.padding()
                    .accessibilityHidden(true)
            }.if(tracks.isEmpty) { _ in
                EmptyStateView {
                    searchText = ""
                    filters = []
                }
            }
        }
        Spacer()
    }

    var headerView: some View {
        VStack(alignment: .center) {
            Image("trackImages")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 170)
            Text("66 languages for you to master").font(.largeTitle)
            Text("Become fluent in your chosen programming languages by completing these tracks created by our awesome team of contributors")
                .multilineTextAlignment(.center)
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}


struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksListView(asyncModel: AsyncModel { PreviewData.shared.getTrack() })
    }
}

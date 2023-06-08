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
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(tracks.filter { $0.isJoined }) { track in
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
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(tracks.filter { !$0.isJoined }) { track in
                                Button {
                                    coordinator.goToTrack(track)
                                } label: {
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding()
                        .accessibilityHidden(true)
                }
            }
        }.accessibilityLabel("All Tracks")
                    .onChange(of: searchText) { newSearch in
                        asyncModel.filterOperations = { self.model.filterTracks(newSearch) }
                    }.onChange(of: filters) { newFilters in
                        print(newFilters.count)
                        asyncModel.filterOperations = { self.model.filterTags(newFilters) }
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
                .multilineTextAlignment(.center)
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

//
//struct TracksView_Previews: PreviewProvider {
//    static var previews: some View {
//        TracksListView()
//    }
//}

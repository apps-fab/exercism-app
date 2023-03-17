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

    let columns = [
        GridItem(.adaptive(minimum: 600, maximum: 1000))
    ]

    var body: some View {
        VStack {
            VStack {
                headerView
                    .background(Color("darkBackground"))
                    .frame(maxWidth: 650, maxHeight: 160)
                    .padding()
                Divider().frame(height: 1)
                FilterView(results: model.tracks.count,
                           searchText: $searchText,
                           filters: $filters) {
                    model.filter(.SortTracks)
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
                        ForEach(listData.0) { track in
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
                        ForEach(listData.1) { track in
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
        }.accessibilityLabel("All Tracks")
            .task {
                do {
                    try await model.tracks()
                } catch {
                    //show error
                }
            } .onChange(of: searchText) { newSearch in
                model.filter(.SearchTracks(query: newSearch))
            }.onChange(of: filters) { newFilters in
                print(newFilters.count)
                model.filter(.FilterTags(tags: newFilters))
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

    var listData: ([Track], [Track]) {
        return (model.tracks.filter { $0.isJoined }, model.tracks.filter { !$0.isJoined })
    }
}


struct TracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksListView()
    }
}

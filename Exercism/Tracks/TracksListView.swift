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
                    .background(Color.darkBackground)
                    .frame(maxHeight: 160)
                    .padding()
                Divider().frame(height: 1)
                FilterView(results: tracks.count,
                           searchText: $searchText,
                           filters: $filters) {
                    asyncModel.filterOperations = { self.model.sortTracks() }
                }.frame(maxHeight: 50)
                    .padding()
                Divider().frame(height: 1)
            }.background(Color.darkBackground)
            ScrollView {
                VStack(alignment: .leading) {
                    Text(Strings.joinedTracks.localized())
                        .font(.largeTitle)
                        .padding()
                        .if(joined.isEmpty) { text in
                            text.hidden()
                        }
                    LazyVGrid(columns: columns) {
                        ForEach(joined) { track in
                            Button {
                                coordinator.goToTrack(track)
                            } label: {
                                TrackGridView(track: track).accessibilityElement(children: .contain)
                            }.buttonStyle(.plain)
                        }
                    }
                    
                    Text(Strings.unjoinedTracks.localized())
                        .font(.largeTitle)
                        .padding()
                        .if(unjoined.isEmpty) { text in
                            text.hidden()
                        }
                    LazyVGrid(columns: columns) {
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
            Image.trackImages
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 170)
            Text(Strings.languageNumber.localized())
                .font(.largeTitle)
            Text(Strings.languageIntro.localized())
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

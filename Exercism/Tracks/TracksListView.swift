//
//  TracksListView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TracksListView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var searchText = ""
    @State private var filters = Set<String>()
    @State var asyncModel: AsyncModel<[Track]>
    private let model = TrackModel.shared
    
    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        AsyncResultView(source: asyncModel) { tracks in
            HStack(spacing: 0) {
                SideBar(tracks: tracks)
                    .frame(minWidth: 250, maxWidth: 280)
                Divider()
                tracksView(tracks)
            }
        }
        .toolbar(.visible)
        .accessibilityLabel("All Tracks")
        .onChange(of: searchText) { newSearch in
            asyncModel.filterOperations = { self.model.filterTracks(newSearch)
            }
        }
        .onChange(of: filters) { newFilters in
            asyncModel.filterOperations = { self.model.filterTags(newFilters) }
        }
    }
    
    @ViewBuilder
    func tracksView(_ tracks: [Track]) ->  some View {
        let joinedTracks = tracks.filter { $0.isJoined }
        let unjoinedTracks = tracks.filter { !$0.isJoined }
        
        VStack(spacing: 0) {
            VStack {
                headerView
                    .padding()
                
                FilterView(
                    results: tracks.count,
                    searchText: $searchText,
                    filters: $filters) {
                        asyncModel.filterOperations = { self.model.sortTracks()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .background(Color.darkBackground)
            
            ScrollView {
                if tracks.isEmpty {
                    EmptyStateView {
                        searchText = ""
                        filters = []
                    }
                } else {
                    VStack(alignment: .leading) {
                        if !joinedTracks.isEmpty {
                            Text(Strings.joinedTracks.localized())
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            LazyVGrid(
                                columns: gridColumns,
                                alignment: .leading
                            ) {
                                ForEach(joinedTracks) { track in
                                    Button {
                                        navigationModel.goToTrack(track)
                                    } label: {
                                        TrackGridView(track: track)
                                            .accessibilityElement(children: .contain)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        if !unjoinedTracks.isEmpty {
                            Text(Strings.unjoinedTracks.localized())
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            LazyVGrid(
                                columns: gridColumns,
                                alignment: .leading
                            ) {
                                ForEach(unjoinedTracks) { track in
                                    TrackGridView(track: track).accessibilityElement(children: .contain)
                                }
                            }
                        }
                    }
                    .padding()
                    .accessibilityHidden(true)
                }
            }
        }
        .frame(minWidth: 850)
    }
    
    var headerView: some View {
        VStack(alignment: .center) {
            Image.trackImages
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 400, minHeight: 50)

            Text(Strings.languageNumber.localized())
                .font(.largeTitle.bold())
                .minimumScaleFactor(0.9)

            Text(LocalizedStringKey(Strings.languageIntro.localized()))
                .font(.title2)
                .minimumScaleFactor(0.9)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TracksListView(asyncModel: AsyncModel { PreviewData.shared.getTrack() })
}

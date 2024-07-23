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
    @AppStorage("shouldRefreshFromJoinTrack") private var shouldRefreshFromJoinTrack = false
    @State private var searchText = ""
    @State private var filters = Set<String>()
    @State var asyncModel: AsyncModel<[Track]>
    private let model = TrackModel.shared

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let refreshPublisher = NotificationCenter.default.publisher(for: .didRequestRefresh)

    var body: some View {
        GeometryReader { size in
            AsyncResultView(source: asyncModel) { tracks in
                HStack {
                    SideBar(tracks: tracks).frame(maxWidth: size.size.width * 0.2)
                    Divider().frame(width: 2)
                    tracksView(tracks)
                }
            }
            .toolbar(.hidden)
            .accessibilityLabel("All Tracks")
            .onChange(of: searchText) { newValue in
                asyncModel.filterOperations = { self.model.filterTracks(newValue) }
            }.onChange(of: filters) { newValue in
                asyncModel.filterOperations = { self.model.filterTags(newValue) }
            }
        }
        .onReceive(refreshPublisher) { _ in
            self.asyncModel = .init(operation: { try await model.getTracks() })
        }
        #if os(macOS)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
            if shouldRefreshFromJoinTrack {
                self.asyncModel = .init(operation: { try await model.getTracks() })
                shouldRefreshFromJoinTrack = false
            }
        }
        #else
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if shouldRefreshFromJoinTrack {
                self.asyncModel = .init(operation: { try await model.getTracks() })
                shouldRefreshFromJoinTrack = false
            }
        }
        #endif
    }

    @ViewBuilder
    func tracksView(_ tracks: [Track]) -> some View {
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
            .background(Color.appDarkBackground)

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
    TracksListView(asyncModel: AsyncModel { PreviewData.shared.getTracks() })
}

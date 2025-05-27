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
    @StateObject private var viewModel = TrackViewModel()
    @State private var searchText = ""
    @State private var filters = Set<String>()

    private let gridColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let refreshPublisher = NotificationCenter.default.publisher(for: .didRequestRefresh)

    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let tracks):
                GeometryReader { size in
                    HStack {
                        SideBar(tracks: tracks)
                            .frame(maxWidth: size.size.width * 0.2)
                        Divider().frame(width: 2)
                        tracksView(tracks)
                    }
                }
            case .failure(let error):
                Text(error.description)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.toolbar(.hidden)
            .accessibilityLabel("All Tracks")
            .onChange(of: searchText) { newValue in
                viewModel.filterTracks(newValue)
            }
            .onChange(of: filters) { newValue in
                viewModel.filterTags(newValue)
            }
            .onReceive(refreshPublisher) { _ in
                Task {
                    await viewModel.getTracks()
                }
            }
#if os(macOS)
            .onReceive(NotificationCenter.default.publisher(for: NSApplication.willBecomeActiveNotification)) { _ in
                if shouldRefreshFromJoinTrack {
                    Task {
                        await viewModel.getTracks()
                        shouldRefreshFromJoinTrack = false
                    }
                }
            }
#else
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                if shouldRefreshFromJoinTrack {
                    Task {
                        await viewModel.getTracks()
                        shouldRefreshFromJoinTrack = false
                    }
                }
            }
#endif
    }

    @ViewBuilder
    func tracksView(_ tracks: [Track]) -> some View {
        let joinedTracks = tracks.filter { $0._isJoined }
        let unjoinedTracks = tracks.filter { !$0._isJoined }

        VStack(spacing: 0) {
            VStack {
                headerView
                    .padding()

                FilterView(searchText: $searchText,
                           filters: $filters,
                           results: tracks.count) {
                    viewModel.sortTracks()
                }.padding()
                    .frame(maxWidth: .infinity)
            }.frame(maxWidth: .infinity)
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
                            LazyVGrid(columns: gridColumns,
                                      alignment: .leading) {
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

                            LazyVGrid(columns: gridColumns, alignment: .leading) {
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

            Text(Strings.languageIntro.localized()
                .getLink(Color.appAccent,
                         linkText: "our awesome team of contributors",
                         linkURL: "https://exercism.org/contributing/contributors"))
            .font(.title2)
            .minimumScaleFactor(0.9)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    TracksListView()
}

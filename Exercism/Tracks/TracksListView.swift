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

    private let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    private let refreshPublisher = NotificationCenter.default.publisher(for: .didRequestRefresh)

    var body: some View {
        VStack {
            mainContent
        }
        .toolbar(.hidden)
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
    private var mainContent: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
        case .loading:
            loadingView
        case .success(let tracks):
            successView(tracks)
        case .failure(let error):
            errorView(error)
        }
    }

    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ error: ExercismClientError) -> some View {
        Text(error.description)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func successView(_ tracks: [Track]) -> some View {
        GeometryReader { geometry in
            HStack {
                SideBar(tracks: tracks)
                    .frame(maxWidth: geometry.size.width * 0.2)
                Divider().frame(width: 2)
                tracksView(tracks)
            }
        }
    }

    @ViewBuilder
    private func tracksView(_ tracks: [Track]) -> some View {
        let joinedTracks = tracks.filter(\._isJoined)
        let unjoinedTracks = tracks.filter { !$0._isJoined }

        VStack(spacing: 0) {
            headerSection(tracks)
            ScrollView {
                if tracks.isEmpty {
                    EmptyStateView {
                        searchText = ""
                        filters = []
                    }
                } else {
                    trackGrid(joinedTracks: joinedTracks, unjoinedTracks: unjoinedTracks)
                }
            }
        }
        .frame(minWidth: 850)
    }

    private func headerSection(_ tracks: [Track]) -> some View {
        VStack {
            headerView
                .padding()

            FilterView(searchText: $searchText,
                       filters: $filters,
                       results: tracks.count) {
                viewModel.sortTracks()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appDarkBackground)
    }

    private func trackGrid(joinedTracks: [Track], unjoinedTracks: [Track]) -> some View {
        VStack(alignment: .leading) {
            if !joinedTracks.isEmpty {
                Text(Strings.joinedTracks.localized())
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                LazyVGrid(columns: gridColumns, alignment: .leading) {
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
                        TrackGridView(track: track)
                            .accessibilityElement(children: .contain)
                    }
                }
            }
        }
        .padding()
        .accessibilityHidden(true)
    }

    private var headerView: some View {
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

    private func handleJoinTrackRefresh() {
        guard shouldRefreshFromJoinTrack else { return }
        Task {
            await viewModel.getTracks()
            shouldRefreshFromJoinTrack = false
        }
    }
}

#Preview {
    TracksListView()
}

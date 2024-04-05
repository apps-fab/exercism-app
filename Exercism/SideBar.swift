//
//  SideBar.swift
//  Exercism
//
//  Created by Angie Mugo on 23/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import ExercismSwift

struct SideBar: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    let tracks: [Track]

    private var joinedTracks: [Track] {
        tracks.filter(\.isJoined)
    }

    var body: some View {
        List {
            ForEach(joinedTracks) { track in
                TrackRowView(track: track) {
                    navigationModel.goToTrack(track)
                }
                .listRowSeparator(.visible)
                .buttonStyle(.plain)
            }
        }
        .safeAreaInset(edge: .top) {
            Text(Strings.joinedTracks.localized())
                .font(.title.bold())
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thickMaterial)
        }
    }

    @MainActor
    private func logout() {
        ExercismKeychain.shared.removeItem(for: Keys.token.rawValue)
        navigationModel.goToLogin()
    }
}

private extension SideBar {
    struct TrackRowView: View {
        let track: Track
        let action: () -> Void
        var body: some View {
            Button(action: action) {
                HStack(alignment: .top) {
                    WebImage(url: URL(string: track.iconUrl))
                        .resizable()
                        .frame(width: 40, height: 40)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(track.slug.capitalized)
                            .font(.title3.bold())

                        Label {
                            Text(String(format: Strings.exerciseNumber.localized(),
                                        track.numCompletedExercises,
                                        track.numExercises))
                        } icon: {
                            Image.dumbell
                                .foregroundStyle(.foreground)
                        }

                        if let lastTouchedAt = track.lastTouchedAt {
                            Text(String(format: Strings.lastTouched.localized(),
                                        lastTouchedAt.offsetFrom()))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Image.chevronRight
                        .frame(maxHeight: .infinity)
                }
                .contentShape(Rectangle())
            }
        }
    }
}

#Preview {
    SideBar(tracks: PreviewData.shared.getTrack())
}

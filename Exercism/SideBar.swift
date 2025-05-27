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
    @State private var showingAlert = false
    let tracks: [Track]

    private var joinedTracks: [Track] {
        tracks.filter(\._isJoined)
    }

    var body: some View {
        List(joinedTracks) { track in
                TrackRowView(track: track) {
                    navigationModel.goToTrack(track)
                }
                .listRowSeparator(.visible)
                .buttonStyle(.plain)
        }.listStyle(.plain)
        .safeAreaInset(edge: .top) {
            Text(Strings.joinedTracks.localized())
                .font(.title.bold())
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thickMaterial)
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Divider()
                Button {
                    showingAlert = true
                } label: {
                    Text(Strings.signOut.localized())
                }.font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .buttonStyle(.plain)
                    .padding()
            }.background(.thickMaterial)
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text(Strings.logOutAlert.localized()),
                  primaryButton: .default(Text("Yes"), action: logout), secondaryButton: .cancel())
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
                                        track._numCompletedExercises,
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
            }.padding()
        }
    }
}

#Preview {
    SideBar(tracks: PreviewData.shared.getTracks())
}

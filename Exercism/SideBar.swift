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
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            VStack(alignment: .leading) {
                Text(Strings.joinedTracks.localized())
                    .frame(width: frame.size.width, alignment: .center)
                    .font(.title)
                    .bold()
                    .padding()
                List {
                    ForEach(tracks.filter { $0.isJoined }) { track in
                        Button {
                            navigationModel.goToTrack(track)
                        } label: {
                            HStack(alignment: .top) {
                                WebImage(url: URL(string: track.iconUrl))
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .accessibilityHidden(true)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(track.title)
                                    Label {
                                        Text(String(format: Strings.exerciseNumber.localized(),
                                                    track.numCompletedExercises,
                                                    track.numExercises))
                                    } icon: {
                                        Image.dumbell
                                            .renderingMode(.template)
                                            .foregroundColor(.primary)
                                    }
                                    Text(String(format: Strings.lastTouched.localized(),
                                                track.lastTouchedAt?.offsetFrom() ?? ""))
                                }
                            }
                        }.padding()
                            .listRowSeparator(.visible)
                            .buttonStyle(.plain)
                    }
                }.listStyle(.plain)
                Divider()
                Button(Strings.signOut.localized()) {
                    logout()
                }
                .foregroundStyle(.red)
                .buttonStyle(.plain)
                .padding()
                
            }
            .background(.ultraThickMaterial)
        }
        
        .safeAreaInset(edge: .top) {
            Text(Strings.joinedTracks.localized())
                .font(.title.bold())
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thickMaterial)
        }
    }

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

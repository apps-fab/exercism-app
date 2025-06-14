//
//  SideBar.swift
//  Exercism
//
//  Created by Angie Mugo on 23/03/2023.
//

import SwiftUI
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

#Preview {
    SideBar(tracks: PreviewData.shared.getTracks())
}

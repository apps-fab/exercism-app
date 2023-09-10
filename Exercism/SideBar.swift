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
    @State var tracks: [Track]
    
    var body: some View {
        GeometryReader { frame in
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
                                    Text(track.slug)
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
                Spacer()
                HStack {
                    Image.profile
                        .resizable()
                        .frame(width: 32, height: 32)
                    VStack {
                        Text("Angie Mugo")
                        Text("@AngieMugo")
                    }
                    Spacer()
                    Image.logout.padding()
                }.padding([.leading, .top])
                Divider().padding()
                Button(Strings.signOut.localized()) {
                    logout()
                }.buttonStyle(.plain)
                    .padding()
            }
        }
    }

    func logout() {
        ExercismKeychain.shared.removeItem(for: Keys.token.rawValue)
        navigationModel.goToLogin()
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(tracks: [])
    }
}

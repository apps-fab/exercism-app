//
//  TrackGridView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift
import SDWebImageSwiftUI

struct TrackGridView: View {
    var track: Track
    @State var isHover = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            WebImage(url: URL(string: track.iconUrl))
                .resizable()
                .frame(alignment: .leading)
                .padding([.top, .leading], 10)
                .frame(width: 100, height: 100)
                .accessibilityHidden(true)
            trackView
                .frame(width: 450, height: 100)
                .padding()
        }.frame(width: 600, height: 150)
            .roundEdges(backgroundColor: Color("darkBackground"), lineColor: .clear)
            .scaleEffect(isHover ? 1.1 : 1)
            .onHover { hover in
                if track.isJoined {
                    withAnimation {
                        isHover = hover
                    }
                }
            }
    }

    var trackView: some View {
        VStack(alignment: .leading) {
            HStack() {
                Text(track.title).bold()
                if track.course && !track.isJoined {
                    Label("Learning Mode", systemImage: "checkmark")
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }

                if track.isNew && !track.isJoined {
                    Label(title: {
                        Text("New")
                    }, icon: {
                        Image("stars")
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                    }).roundEdges(backgroundColor: Color.blue.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                }

                if track.isJoined {
                    Spacer()
                    Label("Joined", systemImage: "checkmark")
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            HStack() {
                Label(title: {
                    track.isJoined ? Text("\(track.numCompletedExercises)/\(track.numExercises) exercises") : Text("\(track.numExercises) exercises")
                }, icon: {
                    Image("exercise")
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })

                Label(title: {
                    Text("\(track.numConcepts) concepts")
                }, icon: {
                    Image("concept")
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })
            }
            if track.isJoined {
                VStack {
                    Text("Last touched \(track.lastTouchedAt?.offsetFrom() ?? "") ago")
                    let value = track.numCompletedExercises > 0 ? Float(track.numCompletedExercises) / Float(track.numExercises) :  0
                    ProgressView(value: value)
                        .accessibilityHidden(true)
                }
            } else {
                HStack() {
                    ForEach(track.tags.prefix(3), id: \.self) { track in
                        Text(track).bold().roundEdges()
                    }
                }
            }
        }
    }
}

//struct TrackGridView_Previews: PreviewProvider {
//    static var previews: some View {
////        TrackGridView(track: TracksViewModel(coordinator: AppCoordinator()).joinedTracks[0])
//    }
//}

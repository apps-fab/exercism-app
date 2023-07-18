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
            .roundEdges(backgroundColor: Color("darkBackground"), lineColor: isHover ? .purple : .clear)
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
                    Label(Strings.learningMode.localized(), systemImage: "checkmark")
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }

                if track.isNew && !track.isJoined {
                    Label(title: {
                        Text(Strings.new.localized())
                    }, icon: {
                        ExercismImages.starsLogo.image()
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                    }).roundEdges(backgroundColor: Color.blue.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                }

                if track.isJoined {
                    Spacer()
                    Label(Strings.joined.localized(), systemImage: "checkmark")
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            HStack() {
                Label(title: {
                    track.isJoined ? Text(String(format: Strings.completedExercises.localized(), track.numCompletedExercises, track.numExercises)) : Text(String(format: Strings.exercises.localized(), track.numExercises))
                }, icon: {
                    ExercismImages.exerciseLogo.image()
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })

                Label(title: {
                    Text(String(format: Strings.concepts.localized(), track.numConcepts))
                }, icon: {
                    ExercismImages.conceptLogo.image()
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })
            }
            
            if track.isJoined {
                let value = track.numCompletedExercises > 0 ? Float(track.numCompletedExercises) / Float(track.numExercises) :  0

                let gradient = Gradient(colors: [.purple, .indigo, .purple])
                Gauge(value: value) {
                    //
                } currentValueLabel: {
                    let dateAgo = track.lastTouchedAt?.offsetFrom() ?? ""
                    Text(String(format: Strings.lastTouched.localized(), dateAgo))
                }.tint(gradient)
                    .gaugeStyle(.accessoryLinearCapacity)
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
//        let token = ExercismKeychain.shared.get(for: Keys.token.rawValue)
//        let client = ExercismClient(apiToken: token!)
//        let fetcher = Fetcher(client: client)
//        let modelData = TrackModel(fetcher: fetcher)
//        TrackGridView(track: modelData.tracks[0])
//            .environmentObject(modelData)
//    }
//}

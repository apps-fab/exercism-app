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
                .padding()
        }.frame(width: 550, height: 150)
            .roundEdges(backgroundColor: Color.darkBackground,
                        lineColor: isHover ? .purple : .clear)
            .padding()
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
                    Label{
                        Text( Strings.learningMode.localized())
                    } icon: {
                        Image.checkmark
                    }.roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }
                
                if track.isNew && !track.isJoined {
                    Label(title: {
                        Text(Strings.new.localized())
                    }, icon: {
                        Image.starsLogo
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                    }).roundEdges(backgroundColor: Color.blue.opacity(0.5))
                        .font(.system(size: 12, weight: .semibold))
                }
                
                if track.isJoined {
                    Spacer()
                    Label {
                        Text( Strings.joined.localized())
                    } icon: {
                        Image.checkmark
                    }.roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple],
                                                                 startPoint: .leading, endPoint: .trailing),
                                 lineColor: .clear)
                    .font(.system(size: 12, weight: .semibold))
                }
            }

            HStack() {
                Label(title: {
                    track.isJoined ? Text(String(format: Strings.completedExercises.localized(), track.numCompletedExercises, track.numExercises)) : Text(String(format: Strings.exercises.localized(), track.numExercises))
                }, icon: {
                    Image.exerciseLogo
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })  
                
                Label(title: {
                    Text(String(format: Strings.concepts.localized(), track.numConcepts))
                }, icon: {
                    Image.conceptLogo
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                })
            }
            
            if track.isJoined {
                let completedExercises = Float(track.numCompletedExercises)
                let numberOfExercises = Float(track.numExercises)

                let gradient = Gradient(colors: [.purple, .indigo, .purple])
                Gauge(value: completedExercises, in: completedExercises...numberOfExercises) {
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

            if !track.isJoined {
                HStack {
                    Link(destination: URL(string: "https://exercism.org/tracks/\(track.slug)")!) {
                        Text("View Track")
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                            .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple],
                                                                        startPoint: .leading, endPoint: .trailing),
                                        lineColor: .clear)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    Spacer()
                    Button(action: {
                        // TODO: Kirk: Add the join track action
                        print("Attempting to join track")
                    }, label: {
                            Text("Join Track")
                        }).buttonStyle(.plain)
                        .padding(.horizontal)
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple],
                                                                     startPoint: .leading, endPoint: .trailing),
                                     lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }

            }
        }
    }
}

#Preview {
    TrackGridView(track: PreviewData.shared.getTrack()[0], isHover: true)
}

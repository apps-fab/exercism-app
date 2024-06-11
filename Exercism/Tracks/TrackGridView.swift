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
    @Environment(\.openURL) private var openURL
    @AppStorage("shouldRefreshFromJoinTrack") private var shouldRefreshFromJoinTrack = false
    
    var track: Track
    @State var isHover = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            WebImage(url: URL(string: track.iconUrl))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.top, .leading], 10)
                .frame(width: 100, height: 100)
                .accessibilityHidden(true)
            trackView
                .padding()
        }
        .frame(idealWidth: 450, maxWidth: .infinity, alignment: .leading)
        .frame(height: 150)
        .roundEdges(
            backgroundColor: Color.exercismDarkBackground,
            lineColor: isHover ? .purple : .clear,
            cornerRadius: 15
        )
        .shadow(color: .offBlackShadow, radius: 15, x: 10, y: 10)
        .shadow(color: .offWhiteShadow, radius: 15, x: -10, y: -10)
        .padding()
        .scaleEffect(isHover ? 1.05 : 1)
        .onHover { hover in
            if track.isJoined {
                withAnimation {
                    isHover = hover
                }
            }
        }
    }
    
    private var trackView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(track.title)
                    .font(.title3.bold())
                
                if track.course && !track.isJoined {
                    Label{
                        Text( Strings.learningMode.localized())
                    } icon: {
                        Image.checkmark
                    }
                    .roundEdges(
                        backgroundColor: LinearGradient(
                            colors: [.indigo.opacity(0.4),
                                     .purple.opacity(0.8),
                                     .purple.opacity(0.5)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing),
                        lineColor: .clear,
                        cornerRadius: 8)
                    .foregroundStyle(.secondary)
                    .font(.callout.weight(.semibold))
                }

                if track.isNew && !track.isJoined {
                    Label(title: {
                        Text(Strings.new.localized())
                    }, icon: {
                        Image.starsLogo
                            .renderingMode(.template)
                            .foregroundColor(.yellow)
                    })
                    .roundEdges(
                        backgroundColor: Color.blue.opacity(0.5)
                    )
                    .font(.callout.weight(.semibold))
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
                } else {
                    Spacer()
                    Button(action: {
                        shouldRefreshFromJoinTrack = true
                        openURL(URL(string: "https://exercism.org/tracks/\(track.slug)")!)
                    }, label: {
                            Text(Strings.joinTrack.localized())
                        }).buttonStyle(.plain)
                        .padding(.horizontal)
                        .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple],
                                                                     startPoint: .leading, endPoint: .trailing),
                                     lineColor: .clear)
                        .font(.system(size: 12, weight: .semibold))
                }
            }
            
            HStack(spacing: 20) {
                Label(title: {
                    if track.isJoined {
                        Text(String(format: Strings.completedExercises.localized(), track.numCompletedExercises, track.numExercises))
                            .fontWeight(.medium)
                    } else {
                        Text(String(format: Strings.exercises.localized(), track.numExercises))
                            .fontWeight(.medium)
                    }
                }, icon: {
                    Image.exerciseLogo
                        .renderingMode(.template)
                        .foregroundStyle(.foreground)
                })
                
                Label(title: {
                    Text(String(format: Strings.concepts.localized(), track.numConcepts))
                        .fontWeight(.medium)
                }, icon: {
                    Image.conceptLogo
                        .renderingMode(.template)
                        .foregroundStyle(.foreground)
                })
            }
            
            if track.isJoined {
                let completedExercises = Float(track.numCompletedExercises)
                let numberOfExercises = Float(track.numExercises)
                
                let gradient = Gradient(colors: [.purple, .indigo, .purple])
                Gauge(value: completedExercises, in: 0...numberOfExercises) {
                } currentValueLabel: {
                    if let lastTouchedAt = track.lastTouchedAt {
                        Text(String(format: Strings.lastTouched.localized(), lastTouchedAt.offsetFrom()))
                    }
                }
                .tint(gradient)
                .gaugeStyle(.accessoryLinearCapacity)
            } else {
                HStack {
                    ForEach(track.tags.prefix(3), id: \.self) { track in
                        Text(track)
                            .fontWeight(.medium)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .foregroundStyle(.secondary)
                            .roundEdges()
                    }
                }
            }
        }
    }
}

#Preview {
    TrackGridView(track: PreviewData.shared.getTracks()[0])
}

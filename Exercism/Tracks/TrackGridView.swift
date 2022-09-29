//
//  TrackGridView.swift
//  Exercism
//
//  Created by Angie Mugo on 26/09/2022.
//

import SwiftUI
import ExercismSwift

struct TrackGridView: View {
    @EnvironmentObject var modelData: TracksViewModel
    var track: Track
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image("mainLogo")
                .resizable().frame(alignment: .leading)
                .padding([.top, .leading], 10)
                .frame(width: 50, height: 50)

            VStack(alignment: .leading) {
                HStack() {
                    Text(track.title).bold()
                    if track.course && !track.isJoined {
                        Label("Learning Mode", systemImage: "checkmark")
                            .roundEdges(backgroundColor: Color("purple"))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    if track.isNew && !track.isJoined {
                        Label("New", image: "stars")
                            .roundEdges(backgroundColor: .blue.opacity(0.5))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    if track.isJoined {
                        Spacer()
                        Label("Joined", systemImage: "checkmark")
                            .roundEdges(backgroundColor: .blue.opacity(0.5))
                            .font(.system(size: 12, weight: .semibold))
                    }
                }
                HStack(spacing: 20) {
                    Label("\(track.numExercises) exercises", image: "exercise")
                    Label("\(track.numConcepts) concepts", image: "concept")
                }
                if track.isJoined {
                    VStack {
                        Text("Last touched \(track.lastTouchedAt?.offsetFrom() ?? "") ago")
                        let value = track.numCompletedExercises > 0 ? Float(track.numCompletedExercises) / Float(track.numExercises) :  0
                        ProgressView(value: value)
                    }
                } else {
                    HStack() {
                        ForEach(track.tags.prefix(3), id: \.self) { track in
                            Text(track).bold().roundEdges(lineColor: .white)
                        }
                    }
                }
            }.frame(width: 350, height: 100)
            .padding()
        }.frame(width: 450, height: 150)
            .border(.gray, width: 1)
            .background(Color("secondaryBackground"))
            .padding()
    }
}

struct TrackGridView_Previews: PreviewProvider {
    static let viewModel = TracksViewModel()
    
    static var previews: some View {
        TrackGridView(track: viewModel.joinedTracks[0])
    }
}

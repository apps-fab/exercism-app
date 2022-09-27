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
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: track.iconUrl)) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                } else if phase.error != nil {
                    Color.red // Indicates an error.
                } else {
                    Color.blue // Acts as a placeholder.
                }
            }.padding([.top, .leading], 10)
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
                        Label("Course", image: "stars")
                            .roundEdges(backgroundColor: .blue.opacity(0.5))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    if track.isJoined {
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
                        Text("Last touched \(3) months ago")
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
            }
        }.frame(width: 450, height: 150)
            .background(.primary)
            .padding()
    }
}

struct TrackGridView_Previews: PreviewProvider {
    static let viewModel = TracksViewModel()
    
    static var previews: some View {
        TrackGridView(track: viewModel.joinedTracks[0])
    }
}

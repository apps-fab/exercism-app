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
            Image("mainLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            HStack {
                VStack {
                    HStack() {
                        Text(track.title)
                        Text("joined")
                    }
                    HStack(spacing: 20) {
                        Label("\(track.numExercises) exercises", image: "exercise")
                        Label("\(track.numConcepts) concepts", image: "concept")
                    }
                    HStack(spacing: 20) {
                        ForEach(track.tags.prefix(3), id: \.self) { track in
                            Text(track)
                                .padding().background(
                                    Capsule().strokeBorder(Color.white, lineWidth: 1).frame(height: 30)
                            ).clipShape(Capsule())
                        }
                    }
                }
            }
        }.padding()
        .background(.secondary)
    }
}

struct TrackGridView_Previews: PreviewProvider {
    static let viewModel = TracksViewModel()

    static var previews: some View {
        TrackGridView(track: viewModel.tracks[0])
    }
}

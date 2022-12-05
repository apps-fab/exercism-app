//
//  ExerciseGridView.swift
//  Exercism
//
//  Created by Angie Mugo on 25/11/2022.
//

import SwiftUI
import ExercismSwift
import SDWebImageSwiftUI

struct ExerciseGridView: View {
    var exercise: Exercise

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            WebImage(url: URL(string: exercise.iconUrl))
                .resizable()
                .frame(width: 64, height: 64)
                .padding([.top, .leading], 10)
            VStack(alignment: .leading) {
                Text(exercise.slug.capitalized)
                    .bold()
                    .font(.title3)
                HStack {
                if exercise.isRecommended {
                    Text("Recommended")
                        .roundEdges(backgroundColor: Color("purple"))
                        .font(.system(size: 12, weight: .semibold))
                    }
                    if !exercise.isUnlocked {
                        Label("Locked", systemImage: "lock")
                            .roundEdges(backgroundColor: .blue.opacity(0.2))
                            .font(.system(size: 12, weight: .semibold))
                    }
                    Text(exercise.type)
                        .roundEdges(backgroundColor: Color("purple"))
                        .font(.system(size: 12, weight: .semibold))
                }
                Text(exercise.blurb)
            }.padding()
            Spacer()
        }.frame(width: 500, height: 150)
                .border(.gray, width: 1)
                .padding()
    }
}

struct ExerciseGridView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGridView(exercise: ExerciseListViewModel(trackName: "Python", coordinator: AppCoordinator()).exercisesList[0])
    }
}

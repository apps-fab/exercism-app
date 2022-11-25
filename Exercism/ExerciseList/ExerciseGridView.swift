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
        HStack(alignment: .top, spacing: 10) {
            WebImage(url: URL(string: exercise.iconUrl))
                .resizable()
                .clipped()
                .frame(width: 64, height: 64)
                .frame(alignment: .leading)
            VStack(alignment: .leading) {
                Text(exercise.slug)
                Label("Learning Mode", systemImage: "checkmark")
                    .roundEdges(backgroundColor: Color("purple"))
                    .font(.system(size: 12, weight: .semibold))
                Text(exercise.blurb)
            }
        }.frame(width: 400, height: 100)
                .border(.gray, width: 1)
    }
}

struct ExerciseGridView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseGridView(exercise: ExerciseListViewModel(trackName: "Python", coordinator: AppCoordinator()).exercisesList[0])
    }
}

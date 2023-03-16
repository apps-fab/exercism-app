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
    @State var isHover = false
    
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
                tags
                Text(exercise.blurb)
            }.padding()
            Spacer()
            Image(systemName: exercise.isUnlocked ? "chevron.right" : "lock")
        }.frame(width: 500, height: 150)
            .roundEdges(backgroundColor: Color("darkBackground"), lineColor: isHover ? .purple : .clear)
            .padding()
            .scaleEffect(isHover ? 1.1 : 1)
            .onHover { hover in
                if exercise.isUnlocked {
                    withAnimation {
                        isHover = hover
                    }
                }
            }
    }
    
    var tags: some View {
        HStack {
            if !exercise.isRecommended && exercise.isUnlocked {
                Label("Completed", systemImage: "checkmark.circle.fill")
                    .roundEdges(backgroundColor: Color.green.opacity(0.2), lineColor: .green)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            if exercise.isRecommended && exercise.isUnlocked {
                Text("In-progress")
                    .roundEdges(backgroundColor: Color.blue.opacity(0.2), lineColor: .blue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            if !exercise.isUnlocked {
                Label("Locked", systemImage: "lock")
                    .roundEdges(backgroundColor: Color.blue.opacity(0.2))
                    .font(.system(size: 12, weight: .semibold))
                if exercise.type == "concept" {
                    Label("Learning Exercise", systemImage: "lightbulb")
                        .roundEdges()
                        .font(.system(size: 12, weight: .semibold))
                } else {
                    Label(exercise.difficulty, systemImage: "square.fill")
                        .roundEdges(backgroundColor: Color.green.opacity(0.2), lineColor: Color("darkBackground"))
                        .font(.system(size: 12, weight: .semibold))
                }
            }
        }
    }
}

struct ExerciseGridView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = TrackModel(client: ExercismClient(apiToken: Keys.token.rawValue))
        ExerciseGridView(exercise: modelData.exercises[0])
            .environmentObject(modelData)
    }
}

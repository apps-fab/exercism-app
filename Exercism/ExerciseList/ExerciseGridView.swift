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
    var solution: Solution?
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
            exercise.isUnlocked ? Image.chevronRight : Image.lock
        }.frame(width: 500, height: 150)
            .roundEdges(backgroundColor: Color.darkBackground, lineColor: isHover ? .purple : .clear)
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
            if solution?.status == .published || solution?.status == .completed {
                Label {
                    Text(Strings.completed.localized())
                } icon: {
                    Image.checkmarkCircleFill
                }.roundEdges(backgroundColor: Color.green.opacity(0.2), lineColor: .green)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.green)
            }
            
            if (solution?.numTterations ?? 0) > 0 {
                // @Todo(Kirk) Convert this to stringdict for proper localisation)
                let iterationText = "\(String(describing: solution!.numTterations)) \(solution!.numTterations == 1 ? "iteration" : "iterations")"
                Label {
                    Text(iterationText)
                } icon: {
                    Image.arrowSquare
                }.font(.system(size: 12, weight: .semibold))
            }
            
            if (exercise.isRecommended && exercise.isUnlocked) || solution?.status == .iterated || solution?.status == .started {
                Text(Strings.inProgress.localized())
                    .roundEdges(backgroundColor: Color.blue.opacity(0.2), lineColor: .blue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            if !exercise.isUnlocked {
                Label {
                    Text(Strings.locked.localized())
                } icon: {
                    Image.lock
                }.roundEdges(backgroundColor: Color.blue.opacity(0.2))
                    .font(.system(size: 12, weight: .semibold))
                if exercise.type == "concept" {
                    Label {
                        Text(Strings.learningExercise.localized())
                    } icon: {
                        Image.lightBulb
                    }.roundEdges()
                        .font(.system(size: 12, weight: .semibold))
                } else {
                    Label {
                        Text(exercise.difficulty)
                    } icon: {
                        Image.squareFill
                    }.roundEdges(backgroundColor: Color.green.opacity(0.2), lineColor: Color.darkBackground)
                        .font(.system(size: 12, weight: .semibold))
                }
            }
        }
    }
}

#Preview {

    ExerciseGridView(exercise: PreviewData.shared.getExercises()[0],
                     solution: PreviewData.shared.getSolutions()[0],
                     isHover: true)
}

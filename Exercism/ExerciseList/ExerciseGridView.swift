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
        HStack(alignment: .top, spacing: 16) {
            WebImage(url: URL(string: exercise.iconUrl))
                .resizable()
                .frame(width: 64, height: 64)

            VStack(alignment: .leading) {
                Text(exercise.slug.capitalized)
                    .font(.title2.bold())
                tags
                Text(exercise.blurb)
                    .font(.title3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                exercise.isUnlocked ? Image.chevronRight : Image.lock
            }
            .frame(maxHeight: .infinity)
        }
        .frame(height: 120)
        .padding(5)
        .roundEdges(
            backgroundColor: Color.appDarkBackground,
            lineColor: isHover ? .appAccent : .clear,
            borderWidth: 1.5,
            cornerRadius: 12
        )
        .shadow(color: Color.appOffBlackShadow, radius: 15, x: 10, y: 10)
        .shadow(color: Color.appOffWhiteShadow, radius: 15, x: -10, y: -10)
        .padding()
        .scaleEffect(isHover ? 1.05 : 1)
        .onHover { hover in
            if exercise.isUnlocked {
                withAnimation {
                    isHover = hover
                }
            }
        }
    }

    private var tags: some View {
        HStack {
            if solution?.status == .published || solution?.status == .completed {
                Label {
                    Text(Strings.completed.localized())
                } icon: {
                    Image.checkmarkCircleFill
                        .foregroundStyle(.foreground, .green)
                }
                .padding(.vertical, 2)
                .roundEdges(
                    backgroundColor: Color.green.opacity(0.2), lineColor: .green)
                .font(.callout.weight(.semibold))
                .foregroundStyle(.green)
            }

            if let numIterations = solution?.numIterations,
               numIterations > 0 {
                // @Todo(Kirk) Convert this to stringdict for proper localisation)
                let iterationText =
                "\(String(describing: numIterations)) \(numIterations == 1 ? "iteration" : "iterations")"
                Label {
                    Text(iterationText)
                } icon: {
                    Image.arrowSquare
                }
                .font(.callout.weight(.semibold))
            }

            if (exercise.isRecommended && exercise.isUnlocked) ||
                solution?.status == .iterated ||
                solution?.status == .started {
                Text(Strings.inProgress.localized())
                    .padding(.vertical, 2)
                    .roundEdges(
                        backgroundColor: Color.blue.opacity(0.2), lineColor: .blue
                    )
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.blue)
            }

            if !exercise.isUnlocked {
                Label {
                    Text(Strings.locked.localized())
                } icon: {
                    Image.lock
                }
                .roundEdges(backgroundColor: Color.blue.opacity(0.2))
                .font(.callout.weight(.semibold))

                if exercise.type == "concept" {
                    Label {
                        Text(Strings.learningExercise.localized())
                    } icon: {
                        Image.lightBulb
                    }
                    .roundEdges()
                    .font(.callout.weight(.semibold))

                } else {
                    Label {
                        Text(exercise.difficulty)
                    } icon: {
                        Image.squareFill
                    }
                    .roundEdges(
                        backgroundColor: Color.green.opacity(0.2),
                        lineColor: Color.appDarkBackground
                    )
                    .font(.callout.weight(.semibold))
                }
            }
        }
    }
}

#Preview("Joined Exercise View") {
    ExerciseGridView(exercise: PreviewData.shared.getExercises()[0],
                     solution: PreviewData.shared.getSolutions()[0],
                     isHover: true)
}

#Preview("Unjoined Exercise View") {
    ExerciseGridView(exercise: PreviewData.shared.getExercises()[1],
                     solution: PreviewData.shared.getSolutions()[0],
                     isHover: true)
}

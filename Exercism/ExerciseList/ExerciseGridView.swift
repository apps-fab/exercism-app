//
//  ExerciseGridView.swift
//  Exercism
//
//  Created by Angie Mugo on 25/11/2022.
//

import SwiftUI
import ExercismSwift
import SDWebImageSwiftUI

extension ExerciseDifficulty {
    var difficultyColor: Color {
        switch self {
        case .easy:
            return .green
        case .medium:
            return .yellow
        case .hard:
            return .red
        }
    }
}

struct ExerciseGridView: View {
    @State private var isHover = false
    let exercise: Exercise
    let solution: Solution?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WebImage(url: URL(string: exercise.iconUrl))
                .resizable()
                .frame(width: 64, height: 64)

            VStack(alignment: .leading) {
                Text(exercise.title.capitalized)
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
            Group {
                switch solution?.status {
                case .published, .completed:
                    statusLabel(
                        text: solution?.status.rawValue.capitalized ?? "",
                        icon: Image.checkmarkCircleFill,
                        color: .green,
                        background: Color.green.opacity(0.2)
                    )

                case .iterated, .started:
                    simpleTag(
                        text: Strings.inProgress.localized(),
                        color: .blue,
                        background: Color.blue.opacity(0.2)
                    )

                default:
                    if !exercise.isUnlocked {
                        statusLabel(
                            text: Strings.locked.localized(),
                            icon: Image.lock,
                            background: Color.blue.opacity(0.2)
                        )
                        statusLabel(
                            text: exercise.type.rawValue.capitalized,
                            icon: Image.lightBulb
                        )
                    } else {
                        simpleTag(text: "Available")
                        statusLabel(
                            text: exercise.difficulty.rawValue.capitalized,
                            icon: Image.stopFill,
                            color: exercise.difficulty.difficultyColor,
                            background: exercise.difficulty.difficultyColor.opacity(0.2)
                        )
                    }
                }
            }

            if let numIterations = solution?.numIterations, numIterations > 0 {
                statusLabel(
                    text: String(format: Strings.iterations.localized(), numIterations),
                    icon: Image.arrowSquare
                )
            }
        }
    }

    @ViewBuilder
    private func statusLabel(text: String,
                             icon: Image,
                             color: Color = .primary,
                             background: Color = .clear) -> some View {
        Label {
            Text(text)
        } icon: {
            icon
                .foregroundStyle(.foreground, color)
        }
        .padding(.vertical, 2)
        .roundEdges(backgroundColor: background, lineColor: color)
        .font(.callout.weight(.semibold))
        .foregroundStyle(color)
    }

    @ViewBuilder
    private func simpleTag(text: String,
                           color: Color = .primary,
                           background: Color = .clear) -> some View {
        Text(text)
            .padding(.vertical, 2)
            .roundEdges(backgroundColor: background, lineColor: color)
            .font(.callout.weight(.semibold))
            .foregroundStyle(color)
    }

}

#Preview("Joined Exercise View") {
    ExerciseGridView(exercise: PreviewData.shared.getExercises()[0],
                     solution: PreviewData.shared.getSolutions()[0])
}

#Preview("Unjoined Exercise View") {
    ExerciseGridView(exercise: PreviewData.shared.getExercises()[1],
                     solution: PreviewData.shared.getSolutions()[0])
}

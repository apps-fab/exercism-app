//
//  TrackRowView.swift
//  Exercode
//
//  Created by Angie Mugo on 09/06/2025.
//

import SwiftUI
import ExercismSwift
import SDWebImageSwiftUI

struct TrackRowView: View {
    let track: Track
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                WebImage(url: URL(string: track.iconUrl))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 10) {
                    Text(track.title)
                        .font(.title3.bold())

                    Label {
                        Text(String(format: Strings.exerciseNumber.localized(),
                                    track._numCompletedExercises,
                                    track.numExercises))
                    } icon: {
                        Image.dumbell
                            .foregroundStyle(.foreground)
                    }

                    if let lastTouchedAt = track.lastTouchedAt {
                        Text(String(format: Strings.lastTouched.localized(),
                                    lastTouchedAt.offsetFrom()))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image.chevronRight
                    .frame(maxHeight: .infinity)
            }
            .contentShape(Rectangle())
        }.padding()
    }
}

#Preview {
    TrackRowView(track: PreviewData.shared.getTracks().first!) {
        print("The tracks")
    }
}

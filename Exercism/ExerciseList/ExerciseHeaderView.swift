//
//  ExerciseHeaderView.swift
//  Exercism
//
//  Created by Angie Mugo on 02/03/2023.
//

import SwiftUI
import ExercismSwift
import SDWebImageSwiftUI

enum _Content: String, CaseIterable, Identifiable {
    case Exercises
    case overview
    case syllabus
    case about
    case buildStatus

    var id: Self { return self }

    var icon: String {
        switch self {
        case .Exercises:
            return "dumbbell.fill"
        case .overview:
            return "square.split.bottomrightquarter.fill"

        case .syllabus:
            return "scale.3d"

        case .about:
            return "exclamationmark.circle"

        case .buildStatus:
            return "hammer"
        }
    }

    func getUrl(_ track: String) -> String {
        switch self {
        case .Exercises:
            return ""
        case .overview:
            return "https://exercism.org/tracks/\(track)"

        case .syllabus:
            return "https://exercism.org/tracks/\(track)"

        case .about:
            return "https://exercism.org/tracks/\(track)/about"

        case .buildStatus:
            return "https://exercism.org/tracks/\(track)/build"
        }
    }
}

struct ExerciseHeaderView: View {
    @Binding var contentSelection: _Content
    let track: Track

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                WebImage(url: URL(string: track.iconUrl))
                    .resizable()
                    .frame(width: 64, height: 64)
                    .padding([.top, .leading], 10)
                Text(track.slug.capitalized)
                    .bold()
                    .font(.title3)
            }

            CustomPicker(selected: $contentSelection) {
                HStack {
                    ForEach(_Content.allCases) { content in
                        VStack {
                            Label(content.rawValue, systemImage: content.icon)
                                .foregroundColor(content == contentSelection ? .purple : .gray)
                            Divider()
                                .frame(height: 2)
                                .background(content == contentSelection ? .purple : .gray)
                        }.padding()
                        .frame(maxWidth: 150)
                            .onTapGesture {
                                contentSelection = content
                            }
                    }
                }
            }
            Divider().frame(height: 2)
        }
    }
}

struct ExerciseHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let token = ExercismKeychain.shared.get(for: Keys.token.rawValue)
        let client = ExercismClient(apiToken: token!)
        let fetcher = Fetcher(client: client)
        let modelData = TrackModel(fetcher: fetcher,
                                   coordinator: AppCoordinator())
        ExerciseHeaderView(contentSelection: .constant(.Exercises),
                           track: modelData.tracks[0])
        .environmentObject(modelData)
    }
}

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
}

struct ExerciseHeaderView: View {
    @Binding var contentSelection: _Content
    @Binding var exerciseCategory: ExerciseCategory
    @Binding var searchText: String
    var resultCount: Int
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
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search by title", text: $searchText)
                        .textFieldStyle(.plain)
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(Color("darkBackground")))
                CustomPicker(selected: $exerciseCategory) {
                    HStack {
                        ForEach(ExerciseCategory.allCases) { option in
                            Text("\(option.rawValue) (\(resultCount))")
                                .padding()
                                .frame(minWidth: 140, maxHeight: 40)
                                .roundEdges(backgroundColor: option == exerciseCategory ? Color.gray : .clear, lineColor: .clear)
                                .onTapGesture {
                                    exerciseCategory = option
                                }
                        }
                    }
                }.padding()
            }.padding()
        }

    }
    
}

struct ExerciseHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = TrackModel(client: ExercismClient(apiToken: Keys.token.rawValue))
        ExerciseHeaderView(contentSelection: .constant(.Exercises),
                           exerciseCategory: .constant(.AllExercises),
                           searchText: .constant("Swift"),
                           resultCount: 1,
                           track: modelData.tracks[0])
        .environmentObject(modelData)
    }
}

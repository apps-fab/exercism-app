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
}

struct ExerciseHeaderView: View {
    let track: Track
    @State var contentSelection: _Content = .Exercises
    @State var exerciseCategory: ExerciseCategory = .AllExercises
    @State private var searchText = ""

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
                            Label(content.rawValue, systemImage: "hammer")
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
                    TextField("Search language filters", text: $searchText)
                        .textFieldStyle(.plain)
                        .onSubmit {
                            // what do when filtering
                        }
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(Color("darkBackground")))
                CustomPicker(selected: $exerciseCategory) {
                    HStack {
                        ForEach(ExerciseCategory.allCases) { option in
                            Text(option.rawValue)
                                .padding()
                                .frame(minWidth: 140, maxHeight: 40)
                                .roundEdges(backgroundColor: option == exerciseCategory ? Color.gray : .clear, lineColor: .clear)
                                .onTapGesture {
                                    exerciseCategory = option
                                }
                        }
                    }
                }.padding()
            }
        }

    }
    
}

//struct ExerciseHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        //ExerciseHeaderView(track: )
//    }
//}

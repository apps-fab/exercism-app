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
            // will use custom view
            Picker("Will change this", selection: $contentSelection) {
                ForEach(_Content.allCases) { content in
                    Label(content.rawValue, systemImage: "hammer")
                }
            }
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
                // will use custom
                Picker("will change this", selection: $exerciseCategory) {
                    ForEach(ExerciseCategory.allCases) { option in
                        Text(option.rawValue)
                    }
                }.pickerStyle(.segmented)
                    .padding()
            }
        }

    }
    
}

//struct ExerciseHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        //ExerciseHeaderView(track: )
//    }
//}

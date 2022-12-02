//
//  ExerciseNavigatorView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 29/09/2022.
//

import SwiftUI
import ExercismSwift

struct ExerciseNavigatorView: View {
    @EnvironmentObject var exerciseObject: ExerciseViewModel
    
    var files: [ExerciseFile] {
        exerciseObject.exercise?.files ?? []
    }
    var selected: ExerciseFile? {
        exerciseObject.selectedFile
    }

    var body: some View {
        List {
            ForEach(files) { file in
                    FileView(file: file, selected: selected == file).onTapGesture {
                            exerciseObject.selectFile(file)
                        }
            }
        }
    }
}

struct FileView: View {
    var file: ExerciseFile
    var selected: Bool = false
    var body: some View {
        GeometryReader { geometry in
            Label(file.name, systemImage: file.iconName)
                .padding(4)
                .frame(width: geometry.size.width, alignment: .leading)
                .if(selected) { view in
                    view.background(.blue)
                }
                .cornerRadius(4)
        }
    }
}

//

//struct ExerciseNavigatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseNavigatorView()
//    }
//}

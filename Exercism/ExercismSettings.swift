//
//  ExercismSettings.swift
//  Exercism
//
//  Created by Angie Mugo on 03/08/2023.
//

import SwiftUI

struct ExercismSettings: View {
    @AppStorage("Editor.theme")private var theme: Int = 0
    
    var body: some View {
        List(selection: $theme) {
            ForEach(0..<3) {_ in
                Text("Red")
            }
        }.frame(width: 300)
            .navigationTitle("Exercism Settings")
            .padding(80)
    }
}

struct ExercismSettings_Previews: PreviewProvider {
    static var previews: some View {
        ExercismSettings()
    }
}

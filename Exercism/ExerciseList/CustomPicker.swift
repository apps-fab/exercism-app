//
//  CustomPicker.swift
//  Exercism
//
//  Created by Angie Mugo on 02/03/2023.
//

import SwiftUI

struct CustomPicker<Content: View, Selection: Identifiable>: View {
    @State var selected: Selection
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
    }
}

#Preview {
    CustomPicker(selected: ExerciseCategory.AllExercises) {
        Text("Some")
    }
}

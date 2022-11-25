//
//  ExerciseRightSidebarView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 29/09/2022.
//

import SwiftUI

struct ExerciseRightSidebarView: View {
    @EnvironmentObject var exerciseObject: ExerciseViewModel
    var instruction: String? {
        exerciseObject.instruction
    }

    var body: some View {
        VStack {
            instruction != nil ? Image(systemName: "checklist") :
            Image(systemName: "text.badge.checkmark")
            Divider()
            if let instruction = instruction {
                Text(instruction)
            }
            Spacer()
        }
    }
}

struct ExerciseRightSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseRightSidebarView()
    }
}

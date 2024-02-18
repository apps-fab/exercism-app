//
//  CustomPicker.swift
//  Exercism
//
//  Created by Angie Mugo on 02/03/2023.
//

import SwiftUI

struct CustomPicker<Content: View, Selection: Identifiable&Equatable>: View {
    @Binding var selected: Selection
    let items: [Selection]
    @ViewBuilder var labelContent: (Selection) -> Content
    
    var body: some View {
        HStack {
            ForEach(items) { item in
                labelContent(item)
                    .fontWeight(
                        item == selected ? .semibold : .regular)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .padding()
                    .frame(height: 34)
                    .roundEdges(backgroundColor: item == selected ? Color.exercismPurple.opacity(0.1) : .clear, lineColor: .clear, cornerRadius: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selected = item
                    }
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

extension CustomPicker where Content == Text {}

#Preview {
    CustomPicker(
        selected: .constant(ExerciseCategory.AllExercises),
        items: ExerciseCategory.allCases) {
            Text("Some \($0.rawValue)")
        }
}

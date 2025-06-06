//
//  CustomPicker.swift
//  Exercism
//
//  Created by Angie Mugo on 02/03/2023.
//

import SwiftUI

struct CustomPicker<Content: View, Selection: Identifiable&Equatable>: View {
    @Binding var selection: Selection
    var items: [Selection]
    @ViewBuilder let labelContent: (Selection) -> Content

    var body: some View {
        HStack {
            ForEach(items) { item in
                labelContent(item)
                    .fontWeight(
                        item == selection ? .semibold : .regular)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .padding()
                    .frame(height: 34)
                    .roundEdges(backgroundColor: item == selection ?
                                Color.appAccent.opacity(0.5) : .clear,
                                lineColor: .clear, cornerRadius: 25)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selection = item
                    }
                    .aspectRatio(contentMode: .fill)
                    .id(item.id)
            }
        }
    }
}

extension CustomPicker where Content == Text {}

#Preview {
    CustomPicker(
        selection: .constant(ExerciseCategory.allExercises),
        items: ExerciseCategory.allCases) {
            Text("Some \($0.rawValue)")
        }
}

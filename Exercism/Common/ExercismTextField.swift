//
//  ExercismTextField.swift
//  Exercism
//
//  Created by Angie Mugo on 22/09/2022.
//

import SwiftUI

struct ExercismTextField: View {
    @Binding var text: String
    var placeholder: Text
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("",
                      text: $text,
                      onEditingChanged: editingChanged,
                      onCommit: commit)
        }.foregroundColor(.gray)
            .padding()
            .textFieldStyle(.plain)
            .accessibilityLabel(text)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}

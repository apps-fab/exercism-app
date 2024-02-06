//
//  ExercismTextField.swift
//  Exercism
//
//  Created by Angie Mugo on 22/09/2022.
//

import SwiftUI

struct ExercismTextField: View {
    @Binding var text: String
    var placeholder: String
    var onSubmit: ()->() = { }
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused)
            .onSubmit {
                onSubmit()
            }.disableAutocorrection(true)
            .padding()
            .textFieldStyle(.plain)
            .accessibilityLabel(text)
            .onTapGesture {
                isFocused = true
            }
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}

struct ExercismTextField_Previews: PreviewProvider {
    static var previews: some View {
        ExercismTextField(text: .constant("Angie"), placeholder: "Enter name")
    }
}

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
    var onSubmit: () -> Void = { }
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

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
#endif

struct ExercismTextField_Previews: PreviewProvider {
    static var previews: some View {
        ExercismTextField(text: .constant("Angie"), placeholder: "Enter name")
    }
}

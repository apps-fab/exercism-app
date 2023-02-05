//
//  RoundedButton.swift
//  Exercism
//
//  Created by Angie Mugo on 30/01/2023.
//

import SwiftUI

struct RoundedRect<background: View>: ViewModifier {
    let radius: CGFloat
    var borderColor: Color
    let backgroundColor: background

    func body(content: Content) -> some View {
        return content
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .background {
                RoundedRectangle(cornerRadius: radius, style: .circular)
                    .strokeBorder(borderColor, lineWidth: 1)
                    .background(backgroundColor)
            }.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}

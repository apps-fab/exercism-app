//
//  RoundedView.swift
//  Exercism
//
//  Created by Angie Mugo on 30/01/2023.
//

import SwiftUI

struct RoundedRect<background: View>: ViewModifier {
    let radius: CGFloat
    let borderColor: Color
    let backgroundColor: background
    // TODO: What's this for?
    @State private var highlight: Bool = false
    
    func body(content: Content) -> some View {
        return content
            .padding([.leading, .trailing], 10)
            .padding([.top, .bottom], 5)
            .background {
                RoundedRectangle(cornerRadius: radius, style: .circular)
                    .strokeBorder(highlight ? .purple : borderColor, lineWidth: 1)
                    .background(backgroundColor)
            }.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}


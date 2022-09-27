//
//  UILabel+Exercism.swift
//  Exercism
//
//  Created by Angie Mugo on 27/09/2022.
//

import SwiftUI

extension Label {
    func roundEdges(backgroundColor: Color = .clear, lineColor: Color = .clear, cornerRadius: CGFloat = 20) -> some View {
        self.padding().background(
            Capsule().strokeBorder(lineColor, lineWidth: 1)
                .frame(height: cornerRadius)
                .background(backgroundColor)
        ).clipShape(Capsule())
    }
}

extension Text {
    func roundEdges(backgroundColor: Color = .clear, lineColor: Color = .clear, cornerRadius: CGFloat = 20) -> some View {
        self.padding().background(
            Capsule().strokeBorder(lineColor, lineWidth: 1)
                .frame(height: cornerRadius)
                .background(backgroundColor)
        ).clipShape(Capsule())
    }
}



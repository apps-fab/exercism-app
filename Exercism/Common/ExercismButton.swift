//
//  ExercismButton.swift
//  Exercism
//
//  Created by Angie Mugo on 05/09/2023.
//

import SwiftUI

struct ExercismButton: View {
    let title: String
    let backgroundColor = Color.exercismPurple
    @Binding var isLoading: Bool
    let action: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            ProgressView()
                .frame(width: 40, height: 40)
                .opacity(isLoading ? 1 : 0)
            Button(action: {
                action()
            }) {
                Text(title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 55)
        .background(backgroundColor)
        .cornerRadius(7)
        .buttonStyle(.plain)
    }
}
//
//  TestErrored.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//
import SwiftUI

struct TestErrored: View {
    let errorDescription: String

    var body: some View {
        VStack {
            Text("AN ERROR OCCURRED.")
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.red)
                .background(.red.opacity(0.2))
                .fontWeight(.bold)
            Text(errorDescription).padding()
            Spacer()
        }
    }
}

#Preview("Test Errored") {
    TestErrored(errorDescription: Strings.errorDescription.localized())
}

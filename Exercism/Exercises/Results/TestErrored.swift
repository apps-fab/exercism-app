//
//  TestErrored.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//
import SwiftUI

struct TestErrored: View {
    var body: some View {
        VStack {
            Text("AN ERROR OCCURRED.")
                .foregroundColor(.red)
                .fontWeight(.bold)
            Text(Strings.errorDescription.localized())
        }
    }
}

#Preview("Test Errored") {
    TestErrored()
}

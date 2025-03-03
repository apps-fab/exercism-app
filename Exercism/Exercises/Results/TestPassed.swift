//
//  TestPassed.swift
//  Exercode
//
//  Created by Angie Mugo on 20/11/2024.
//

import SwiftUI

struct TestPassed: View {
    let onSubmitTest: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(Strings.solvedExercise.localized())
                .font(.headline)
                .bold()
            Text(Strings.submitCode.localized())
                .multilineTextAlignment(.center)
            Button {
                onSubmitTest()
            } label: {
                Label {
                    Text(Strings.submit.localized())
                } icon: {
                    Image.play
                }
                .padding(4)
                .roundEdges(backgroundColor: Color.appAccent)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
    }
}

#Preview("Test Passed") {
    TestPassed {
        print("We passed test")
    }
}

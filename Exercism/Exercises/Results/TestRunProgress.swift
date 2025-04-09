//
//  TestRunProgress.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI

struct TestRunProgress: View {
    @State private var progress = 0.0
    var totalSecs: Double
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    let gradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.appAccent.opacity(0.4),
            Color.appAccent.opacity(0.6),
            Color.appAccent.opacity(0.8),
            Color.appAccent
        ]),
        startPoint: .top,
        endPoint: .bottom
    )

    var body: some View {
        VStack {
            ProgressView(Strings.runningTests.localized(), value: progress, total: 100)
                .tint(gradient)
                .padding()
                .onReceive(timer) { _ in
                    if progress < 100.0 {
                        let tempProgress = min(100, (100.0 / (totalSecs * 10.0)))
                        progress += tempProgress.rounded(.towardZero)
                    }
                }
            Text(String(format: Strings.estimatedTime.localized(), Int(totalSecs)))
        }
    }
}

#Preview {
    TestRunProgress(totalSecs: 0.4)
}

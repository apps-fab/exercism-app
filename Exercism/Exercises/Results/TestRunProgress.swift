//
//  TestRunProgress.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI

struct TestRunProgress: View {
    let totalSecs: Double
    @State private var progress = 0.0
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ProgressView(Strings.runningTests.localized(), value: progress, total: 100)
                .tint(Color.appAccent)
                .padding()
                .onReceive(timer) { _ in
                    if progress < 100 {
                        progress += ((100.0 / (totalSecs * 10.0))).rounded(.towardZero)
                    }
                }
            Text(String(format: Strings.estimatedTime.localized(), Int(totalSecs)))
        }
    }
}

#Preview {
    TestRunProgress(totalSecs: 0.4)
}

//
//  StreakView.swift
//  Exercode
//
//  Created by Angie Mugo on 10/06/2025.
//

import SwiftUI

struct StreakView: View {
    @State private var animation = false
    @Environment(\.streakManager) private var streak

    private let streakColor: Color
    private let backgroundColor: Color
    private let animateOnAppear: Bool
    private let font: Font
    private let imageHeight: CGFloat

    init(streakColor: Color = .orange,
         backgroundColor: Color? = nil,
         animateOnAppear: Bool = true,
         font: Font = .system(size: 18, weight: .bold, design: .rounded),
         imageHeight: CGFloat = 24) {
        self.streakColor = streakColor
        self.animateOnAppear = animateOnAppear
        self.font = font
        self.imageHeight = imageHeight
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = Color(.appOffBlackShadow)
        }
    }

    public var body: some View {
        HStack {
            Text("\(streak.currentStreak.length)")
                .font(font)
            image
        }
        .foregroundStyle(streakColor)
        .roundEdges(cornerRadius: 14)
        .onAppear {
            if streak.hasCompletedStreak() && animateOnAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 5_000_000)
                    animation.toggle()
                }
            }
        }
#if DEBUG
        .onTapGesture {
            withAnimation {
                animation.toggle()
            }
        }
#endif
    }

    @ViewBuilder
    private var image: some View {
        Image(systemName: "flame.circle.fill")
            .resizable()
            .frame(width: imageHeight, height: imageHeight)
            .symbolRenderingMode(.hierarchical)
            .symbolEffect(.bounce, options: .speed(0.8), value: animation)
    }
}

extension EnvironmentValues {
    var streakManager: StreakManager {
        get { self[StreakManager.self] }
        set { self[StreakManager.self] = newValue }
    }
}

extension View {
    func setupStreak(persistence: StreakPersistenceType = .userDefaults) -> some View {
        return self
            .environment(\.streakManager, .init(persistence: persistence.makePersistence()))
    }
}

extension StreakManager: EnvironmentKey {
    static nonisolated(unsafe) public let defaultValue: StreakManager = .init()
}

#Preview {
    StreakView()
}

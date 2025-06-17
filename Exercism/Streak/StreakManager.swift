//
//  StreakManager.swift
//  Exercode
//
//  Created by Angie Mugo on 10/06/2025.
//

import Foundation

class StreakManager: ObservableObject {
    @Published var currentStreak = Streak()
    private let persistence: StreakPersistence

    init(persistence: StreakPersistence = UserDefaults.standard) {
        self.persistence = persistence
        self.currentStreak = loadStreak()
    }

    func hasCompletedStreak(today: Date = .now) -> Bool {
        let outcome = currentStreak.determineOutcome(for: today)
        return outcome == .streakContinues
    }

    func evaluateAndUpdateStreak(for date: Date = .now) {
        let outcome = currentStreak.determineOutcome(for: date)
        switch outcome {
        case .alreadyCompletedToday:
            return
        case .streakContinues:
            currentStreak.length += 1
        case .streakBroken:
            currentStreak.length = 1
        }
        currentStreak.lastDate = date
        save(streak: currentStreak)
    }

    func loadStreak(decoder: JSONDecoder = .init()) -> Streak {
        guard let data = persistence.getData() else {
            return Streak()
        }

        do {
            let fetched = try decoder.decode(Streak.self, from: data)
            return fetched
        } catch {
            debugPrint("Failed to decode streak. Error: \(error.localizedDescription)")
            return Streak()
        }
    }

    func save(streak: Streak, encoder: JSONEncoder = .init()) {
        guard let encoded = try? encoder.encode(streak) else {
            debugPrint("Failed to encode current streak")
            return
        }

        do {
            try persistence.save(data: encoded)
        } catch {
            debugPrint("Error saving streak: \(error)")
        }
    }
}

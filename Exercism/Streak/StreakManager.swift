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

    @MainActor
    func getStreakLength(forDate date: Date = .now) -> Int {
        let outcome = currentStreak.determineOutcome(for: date)
        if outcome == .streakBroken {
            currentStreak.length = 0
            save(streak: currentStreak)
        }
        return currentStreak.length
    }

    func updateStreak(onDate date: Date = .now) {
        let outcome = currentStreak.determineOutcome(for: date)
        switch outcome {
        case .alreadyCompletedToday:
            return
        case .streakContinues:
            currentStreak.lastDate = date
            currentStreak.length += 1
        case .streakBroken:
            currentStreak.lastDate = date
            currentStreak.length = 1
        }
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
            print("Failed to decode streak. Error: \(error.localizedDescription)")
            return Streak()
        }
    }

    func save(streak: Streak, encoder: JSONEncoder = .init()) {
        guard let encoded = try? encoder.encode(streak) else {
            print("Failed to encode current streak")
            return
        }
        do {
            try persistence.save(data: encoded)
        } catch {
            print("Error saving streak: \(error)")
        }
    }

}

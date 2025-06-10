//
//  Streak.swift
//  Exercode
//
//  Created by Angie Mugo on 10/06/2025.
//

import Foundation

struct Streak: Codable {
    var length: Int = 0
    var lastDate: Date?
}

extension Streak {
    func determineOutcome(for date: Date) -> Outcome {
        guard let lastDate else { return .streakContinues }
        let calendar = Calendar.current
        if calendar.isDate(date, inSameDayAs: lastDate) {
            return .alreadyCompletedToday
        }

        if let dayAfterLast = calendar.date(byAdding: .day, value: 1, to: lastDate) {
            if calendar.isDate(date, inSameDayAs: dayAfterLast) {
                return .streakContinues
            }
        }
        return .streakBroken
    }

    enum Outcome {
        case alreadyCompletedToday
        case streakContinues
        case streakBroken
    }
}

class StreakOptions: @unchecked Sendable {
    static let shared: StreakOptions = .init()

    /// The persistence key
    var key: String = "DailyStreak"

    private init() {}
}


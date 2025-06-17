//
//  StreakManagerTests.swift
//  ExercodeTests
//
//  Created by Angie Mugo on 16/06/2025.
//

import XCTest
@testable import Exercode

final class StreakManagerTests: XCTestCase {
    private var mockPersistence: MockPersistence!
    private var streakManager: StreakManager!
    private var calendar: Calendar!

    class MockPersistence: StreakPersistence {
        var storedData: Data?

        func getData() -> Data? {
            storedData
        }

        func save(data: Data) throws {
            storedData = data
        }

        func saveEncoded(_ streak: Streak) {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(streak) {
                try? save(data: encoded)
            }
        }
    }

    override func setUp() {
        super.setUp()
        mockPersistence = MockPersistence()
        streakManager = StreakManager(persistence: mockPersistence)
        calendar = Calendar(identifier: .gregorian)
    }

    override func tearDown() {
        mockPersistence = nil
        streakManager = nil
        calendar = nil
        super.tearDown()
    }

    func testStreakProgression() throws {
        let startDate = calendar.startOfDay(for: Date(timeIntervalSince1970: 0))

        // Simulate starting streak
        streakManager.evaluateAndUpdateStreak(for: startDate)
        XCTAssertEqual(streakManager.currentStreak.length, 1)

        // Simulate next day
        let nextDay = calendar.date(byAdding: .day, value: 1, to: startDate)!
        streakManager.evaluateAndUpdateStreak(for: nextDay)
        XCTAssertEqual(streakManager.currentStreak.length, 2)

        // Simulate skipping a day (should reset)
        let skipDay = calendar.date(byAdding: .day, value: 3, to: startDate)!
        streakManager.evaluateAndUpdateStreak(for: skipDay)
        XCTAssertEqual(streakManager.currentStreak.length, 1)
    }

    func testStreakContinues() {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: .now)!
        let existingStreak = Streak(length: 3, lastDate: yesterday)
        mockPersistence.saveEncoded(existingStreak)

        streakManager = StreakManager(persistence: mockPersistence)

        let outcome = streakManager.currentStreak.determineOutcome(for: .now)
        XCTAssertEqual(outcome, .streakContinues)
    }

    func testStreakBroken() {
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: .now)!
        let existingStreak = Streak(length: 3, lastDate: twoDaysAgo)
        mockPersistence.saveEncoded(existingStreak)

        streakManager = StreakManager(persistence: mockPersistence)

        let outcome = streakManager.currentStreak.determineOutcome(for: .now)
        XCTAssertEqual(outcome, .streakBroken)
    }

    func testAlreadyCompleted() {
        let today = calendar.startOfDay(for: .now)
        let existingStreak = Streak(length: 3, lastDate: today)
        mockPersistence.saveEncoded(existingStreak)

        streakManager = StreakManager(persistence: mockPersistence)

        let outcome = streakManager.currentStreak.determineOutcome(for: .now)
        XCTAssertEqual(outcome, .alreadyCompletedToday)
    }

}

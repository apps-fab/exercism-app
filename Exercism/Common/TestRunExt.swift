// Extensions for [TestRun]
//
// Created by Kirk Agbenyegah on 05/02/2023.
//

import Foundation
import ExercismSwift

extension TestRun {
    var testsByStatus: [TestStatus: [Test]] {
        Dictionary(grouping: tests, by: { $0.status })
    }

    // Check if test run has tasks.
    // Depends on the version if the tests has task id
    func hasTasks() -> Bool {
        version >= 3 && !tasks.isEmpty && tests.allSatisfy {
            $0.taskId != nil
        }
    }

    func numFailedTest() -> Int {
        tests.filter { test in
            test.status == TestStatus.fail || test.status == TestStatus.error
        }
        .count
    }

    func failedTest() -> [Test] {
        tests.filter { test in
            test.status == TestStatus.fail || test.status == TestStatus.error
        }
    }

    func numFailedTasks() -> Int {
        Set(
            failedTest()
                .filter {
                    $0.taskId != nil
                }
                .map {
                    $0.taskId
                }
        )
        .count
    }

    func testGroupedByTaskList() -> [[TestGroup]] {
        if !hasTasks() {
            return testsByStatus.map { _, value in
                value.enumerated().map { testId, test in
                    TestGroup(test: test, testId: testId + 1)
                }
            }
        } else {
            return tasks.map { task in
                let tests = testsByStatus.flatMap { _, value in
                    value.filter {
                        $0.taskId == task.id
                    }
                    .enumerated()
                    .map { testId, test in
                        TestGroup(test: test, task: task, testId: testId + 1)
                    }
                }
                return tests
            }
        }
    }
}

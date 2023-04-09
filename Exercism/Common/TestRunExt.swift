// Extensions for [TestRun]
//
// Created by Kirk Agbenyegah on 05/02/2023.
//

import Foundation
import ExercismSwift

extension TestRun {
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
    
    func testGroupedByTaskList() -> [TestGroup] {
        tasks.map { task in
            let tests = tests.filter {
                $0.taskId == task.id
            }
                .enumerated()
                .map { i, test in
                    TestGroup(test: test, testId: i + 1)
                }
            return TestGroup(task: task, tests: tests)
        }
    }
}

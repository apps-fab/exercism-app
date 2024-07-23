//
// Created by Kirk Agbenyegah on 05/02/2023.
//

import Foundation
import ExercismSwift

struct TestGroup: Identifiable, Hashable {
    let id = UUID()
    let test: Test?
    let testId: Int?
    let task: ExercismTask?
    let tests: [[TestGroup]]?

    init(test: Test? = nil, task: ExercismTask? = nil, tests: [[TestGroup]]? = nil, testId: Int? = nil) {
        self.test = test
        self.task = task
        self.tests = tests
        self.testId = testId
    }

    func passed(taskId: Int) -> Bool {
        tests?.flatMap { $0 }.allSatisfy {
            $0.test?.status == .pass
        } ?? false
    }

    // Hashable & Identifiable
    static func == (lhs: TestGroup, rhs: TestGroup) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}

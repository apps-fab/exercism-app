//
// Created by Kirk Agbenyegah on 05/02/2023.
//

import Foundation
import ExercismSwift

struct TestGroup: Identifiable {
    let id = UUID()
    let test: Test?
    let testId: Int?
    let task: Task?
    let tests: [TestGroup]?

    init(test: Test? = nil, task: Task? = nil, tests: [TestGroup]? = nil, testId: Int? = nil) {
        self.test = test
        self.task = task
        self.tests = tests
        self.testId = testId
    }

    func passed(taskId: Int) -> Bool {
        tests?.allSatisfy {
            $0.test?.status == .pass
        } ?? false
    }
}

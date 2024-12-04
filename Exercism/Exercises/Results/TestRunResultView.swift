// Display result of test run
//
//  Created by Kirk Agbenyegah on 07/02/2023.
//

import SwiftUI
import ExercismSwift
import Splash

struct TestRunResultView: View {
    var testRun: TestRun
    let language: String
    let theme: Splash.Theme
    let onSubmitTest: () -> Void

    var body: some View {
        switch testRun.status {
        case .pass:
            TestPassed(onSubmitTest: onSubmitTest)
        case .error, .ops_error, .timeout:
            TestErrored()
        case .fail:
            VStack {
                TestRunSummaryHeader(testRun: testRun)
                ScrollView {
                    TestGroupedByTaskList(testRun: testRun, language: language, theme: theme)
                }
            }
        default:
            TestRunSummaryHeader(testRun: testRun)
        }
    }
}

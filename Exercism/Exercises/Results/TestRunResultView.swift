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
            TestErrored(errorDescription: testRun.message ?? Strings.errorDescription.localized())
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

#Preview {
    let testRun = PreviewData.shared.testRun()
    TestRunResultView(testRun: testRun,
                      language: "Swift",
                      theme: Splash.Theme(
                        font: Font(size: 14),
                        plainTextColor: Color.black,
                        tokenColors: [TokenType.string: Color.black],
                    backgroundColor: Color(white: 0.12, alpha: 1))) {
        print("we run")
    }
}

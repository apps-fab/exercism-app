// Holds static data for view prviews
//
// Created by Kirk Agbenyegah on 07/02/2023.
//

import Foundation
import ExercismSwift

// swiftlint:disable all
struct PreviewData {
    static let shared = PreviewData()
    let fileManager = FileManager.default
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func testRun() -> TestRun {
        let data = """
                   {
                     "uuid": "52296ea5-da53-4550-856c-eee75b711be3",
                     "submission_uuid": "76838d40e22648a7ad8124094633bb53",
                     "version": 3,
                     "status": "fail",
                     "message": null,
                     "message_html": null,
                     "output": null,
                     "output_html": null,
                     "tests": [
                       {
                         "name": "test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(0, false) == :trace\\nassert LogLevel.to_label(0, true) == :unknown",
                         "message": "  1) test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:6\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(0, false) == :trace\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:trace\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:12: (test)\\n",
                         "message_html": "  1) test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:6\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(0, false) == :trace\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:trace\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:12: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 1 has label debug",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(1, false) == :debug\\nassert LogLevel.to_label(1, true) == :debug",
                         "message": "  2) test LogLevel.to_label/2 level 1 has label debug (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:17\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(1, false) == :debug\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:debug\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:19: (test)\\n",
                         "message_html": "  2) test LogLevel.to_label/2 level 1 has label debug (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:17\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(1, false) == :debug\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:debug\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:19: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 2 has label info",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(2, false) == :info\\nassert LogLevel.to_label(2, true) == :info",
                         "message": "  3) test LogLevel.to_label/2 level 2 has label info (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:24\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(2, false) == :info\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:info\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:26: (test)\\n",
                         "message_html": "  3) test LogLevel.to_label/2 level 2 has label info (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:24\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(2, false) == :info\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:info\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:26: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 3 has label warning",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(3, false) == :warning\\nassert LogLevel.to_label(3, true) == :warning",
                         "message": "  4) test LogLevel.to_label/2 level 3 has label warning (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:31\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(3, false) == :warning\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:warning\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:33: (test)\\n",
                         "message_html": "  4) test LogLevel.to_label/2 level 3 has label warning (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:31\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(3, false) == :warning\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:warning\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:33: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 4 has label error",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(4, false) == :error\\nassert LogLevel.to_label(4, true) == :error",
                         "message": "  5) test LogLevel.to_label/2 level 4 has label error (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:38\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(4, false) == :error\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:error\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:40: (test)\\n",
                         "message_html": "  5) test LogLevel.to_label/2 level 4 has label error (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:38\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(4, false) == :error\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:error\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:40: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 5 has label fatal only in a non-legacy app",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(5, false) == :fatal\\nassert LogLevel.to_label(5, true) == :unknown",
                         "message": "  6) test LogLevel.to_label/2 level 5 has label fatal only in a non-legacy app (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:45\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(5, false) == :fatal\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:fatal\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:51: (test)\\n",
                         "message_html": "  6) test LogLevel.to_label/2 level 5 has label fatal only in a non-legacy app (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:45\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(5, false) == :fatal\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:fatal\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:51: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level 6 has label unknown",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(6, false) == :unknown\\nassert LogLevel.to_label(6, true) == :unknown",
                         "message": "  7) test LogLevel.to_label/2 level 6 has label unknown (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:56\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(6, false) == :unknown\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:unknown\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:58: (test)\\n",
                         "message_html": "  7) test LogLevel.to_label/2 level 6 has label unknown (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:56\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(6, false) == :unknown\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:unknown\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:58: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.to_label/2 level -1 has label unknown",
                         "status": "pass",
                         "test_code": "assert LogLevel.to_label(-1, false) == :unknown\\nassert LogLevel.to_label(-1, true) == :unknown",
                         "message": "  8) test LogLevel.to_label/2 level -1 has label unknown (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:63\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.to_label(-1, false) == :unknown\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31m[]\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:unknown\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:66: (test)\\n",
                         "message_html": "  8) test LogLevel.to_label/2 level -1 has label unknown (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:63\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.to_label(-1, false) == :unknown\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003e[]\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:unknown\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:66: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 1
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 fatal code sends alert to ops",
                         "status": "fail",
                         "test_code": "assert LogLevel.alert_recipient(5, false) == :ops",
                         "message": "  9) test LogLevel.alert_recipient/2 fatal code sends alert to ops (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:80\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.alert_recipient(5, false) == :ops\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31mnil\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:ops\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:85: (test)\\n",
                         "message_html": "  9) test LogLevel.alert_recipient/2 fatal code sends alert to ops (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:80\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.alert_recipient(5, false) == :ops\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003enil\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:ops\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:85: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 error code sends alert to ops",
                         "status": "fail",
                         "test_code": "assert LogLevel.alert_recipient(4, false) == :ops\\nassert LogLevel.alert_recipient(4, true) == :ops",
                         "message": " 10) test LogLevel.alert_recipient/2 error code sends alert to ops (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:89\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.alert_recipient(4, false) == :ops\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31mnil\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:ops\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:94: (test)\\n",
                         "message_html": " 10) test LogLevel.alert_recipient/2 error code sends alert to ops (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:89\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.alert_recipient(4, false) == :ops\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003enil\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:ops\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:94: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 unknown code sends alert to dev team 1 for a legacy app",
                         "status": "fail",
                         "test_code": "assert LogLevel.alert_recipient(6, true) == :dev1\\nassert LogLevel.alert_recipient(0, true) == :dev1\\nassert LogLevel.alert_recipient(5, true) == :dev1",
                         "message": " 11) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 1 for a legacy app (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:99\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.alert_recipient(6, true) == :dev1\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31mnil\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:dev1\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:105: (test)\\n",
                         "message_html": " 11) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 1 for a legacy app (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:99\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.alert_recipient(6, true) == :dev1\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003enil\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:dev1\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:105: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2",
                         "status": "fail",
                         "test_code": "assert LogLevel.alert_recipient(6, false) == :dev2",
                         "message": " 12) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2 (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:111\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.alert_recipient(6, false) == :dev2\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31mnil\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:dev2\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:117: (test)\\n",
                         "message_html": " 12) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2 (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:111\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.alert_recipient(6, false) == :dev2\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003enil\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:dev2\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:117: (test)\\n",
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 trace code does not send alert",
                         "status": "pass",
                         "test_code": "refute LogLevel.alert_recipient(0, false)",
                         "message": null,
                         "message_html": null,
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 debug code does not send alert",
                         "status": "pass",
                         "test_code": "refute LogLevel.alert_recipient(1, false)\\nrefute LogLevel.alert_recipient(1, true)",
                         "message": null,
                         "message_html": null,
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 info code does not send alert",
                         "status": "pass",
                         "test_code": "refute LogLevel.alert_recipient(2, false)\\nrefute LogLevel.alert_recipient(2, true)",
                         "message": null,
                         "message_html": null,
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       },
                       {
                         "name": "test LogLevel.alert_recipient/2 warning code does not send alert",
                         "status": "pass",
                         "test_code": "refute LogLevel.alert_recipient(3, false)\\nrefute LogLevel.alert_recipient(3, true)",
                         "message": null,
                         "message_html": null,
                         "expected": null,
                         "output": "",
                         "output_html": "",
                         "task_id": 2
                       }
                     ],
                     "tasks": [
                       {
                         "id": 1,
                         "title": "Return the logging code label"
                       },
                       {
                         "id": 2,
                         "title": "Send an alert"
                       }
                     ],
                     "highlightjs_language": "elixir",
                     "links": {
                       "self": "https://exercism.org/api/v2/solutions/e7bf53557d8145b1ac8eae7227e2e50e/submissions/76838d40e22648a7ad8124094633bb53/test_run"
                     }
                   }
                   """
        return try! decoder().decode(TestRun.self, from: Data(data.utf8))
    }

    func testRunWithoutTasks() -> TestRun {
        let data = """
        {
            "uuid": "52296ea5-da53-4550-856c-eee75b711be3",
            "submission_uuid": "76838d40e22648a7ad8124094633bb53",
            "version": 3,
            "status": "fail",
            "message": null,
            "message_html": null,
            "output": null,
            "output_html": null,
            "tests": [
                {
                    "name": "test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app",
                    "status": "fail",
                    "test_code": "assert LogLevel.to_label(0, false) == :trace\\nassert LogLevel.to_label(0, true) == :unknown",
                    "message": "  1) test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app (LogLevelTest)\\n     test/log_level_test.exs:6\\n     Assertion with == failed\\n     code:  assert LogLevel.to_label(0, false) == :trace\\n     left:  []\\n     right: :trace\\n     stacktrace:\\n       test/log_level_test.exs:12: (test)\\n",
                    "message_html": "  1) test LogLevel.to_label/2 level 0 has label trace only in a non-legacy app (LogLevelTest)\\n     <b><span style='color:#000;'>test/log_level_test.exs:6</span></b>\\n     <span style='color:#A00;'>Assertion with == failed</span>\\n     <span style='color:#0AA;'>code:  </span>assert LogLevel.to_label(0, false) == :trace\\n     <span style='color:#0AA;'>left:  </span><span style='color:#A00;'>[]</span>\\n     <span style='color:#0AA;'>right: </span><span style='color:#0A0;'>:trace</span>\\n     <span style='color:#0AA;'>stacktrace:</span>\\n       test/log_level_test.exs:12: (test)\\n",
                    "expected": null,
                    "output": "",
                    "output_html": "",
                    "task_id": null
                },
                {
                    "name": "test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2",
                    "status": "fail",
                    "test_code": "assert LogLevel.alert_recipient(6, false) == :dev2",
                    "message": " 12) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2 (LogLevelTest)\\n     \\u001b[1m\\u001b[30mtest/log_level_test.exs:111\\u001b[0m\\n     \\u001b[31mAssertion with == failed\\u001b[0m\\n     \\u001b[36mcode:  \\u001b[0massert LogLevel.alert_recipient(6, false) == :dev2\\n     \\u001b[36mleft:  \\u001b[0m\\u001b[31mnil\\u001b[0m\\n     \\u001b[36mright: \\u001b[0m\\u001b[32m:dev2\\u001b[0m\\n     \\u001b[36mstacktrace:\\u001b[0m\\n       test/log_level_test.exs:117: (test)\\n",
                    "message_html": " 12) test LogLevel.alert_recipient/2 unknown code sends alert to dev team 2 (LogLevelTest)\\n     \\u003cb\\u003e\\u003cspan style='color:#000;'\\u003etest/log_level_test.exs:111\\u003c/span\\u003e\\u003c/b\\u003e\\n     \\u003cspan style='color:#A00;'\\u003eAssertion with == failed\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003ecode:  \\u003c/span\\u003eassert LogLevel.alert_recipient(6, false) == :dev2\\n     \\u003cspan style='color:#0AA;'\\u003eleft:  \\u003c/span\\u003e\\u003cspan style='color:#A00;'\\u003enil\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003eright: \\u003c/span\\u003e\\u003cspan style='color:#0A0;'\\u003e:dev2\\u003c/span\\u003e\\n     \\u003cspan style='color:#0AA;'\\u003estacktrace:\\u003c/span\\u003e\\n       test/log_level_test.exs:117: (test)\\n",
                    "expected": null,
                    "output": "",
                    "output_html": "",
                    "task_id": null
                },
                {
                    "name": "test LogLevel.alert_recipient/2 info code does not send alert",
                    "status": "pass",
                    "test_code": "refute LogLevel.alert_recipient(2, false)\\nrefute LogLevel.alert_recipient(2, true)",
                    "message": null,
                    "message_html": null,
                    "expected": null,
                    "output": "",
                    "output_html": "",
                    "task_id": 2
                }
            ],
            "tasks": [],
            "highlightjs_language": "elixir",
            "links": {
                "self": "https://exercism.org/api/v2/solutions/e7bf53557d8145b1ac8eae7227e2e50e/submissions/76838d40e22648a7ad8124094633bb53/test_run"
            }
        }
        """

        return try! decoder().decode(TestRun.self, from: Data(data.utf8))
    }

    func getTracks() -> [Track] {
        let data = """
                         [
            {
                             "slug": "AWK",
                             "title": "AWK",
                             "course": false,
                             "num_concepts": 0,
                             "num_exercises": 59,
                             "web_url": "https://exercism.org/tracks/awk",
                             "icon_url": "https://dg8krxphbh767.cloudfront.net/tracks/awk.svg",
                             "tags": [
                                 "Scripts",
                                 "Procedural",
                                 "Interpreted",
                                 "Standalone executable",
                                 "Weak",
                                 "Linux",
                                 "Mac OSX",
                                 "Windows"
                             ],
                             "last_touched_at": "2023-06-14T18:41:26Z",
                             "is_new": false,
                             "links": {
                                 "self": "https://exercism.org/tracks/awk",
                                 "exercises": "https://exercism.org/tracks/awk/exercises",
                                 "concepts": "https://exercism.org/tracks/awk/concepts"
                             },
                             "is_joined": true,
                             "num_learnt_concepts": 0,
                             "num_completed_exercises": 0,
                             "num_solutions": 2,
                             "has_notifications": false
                         },
              {
                        "slug": "delphi",
                        "title": "Delphi Pascal",
                        "course": false,
                        "num_concepts": 0,
                        "num_exercises": 76,
                        "web_url": "https://exercism.org/tracks/delphi",
                        "icon_url": "https://assets.exercism.org/tracks/delphi.svg",
                        "tags": [
                            "Declarative",
                            "Imperative",
                            "Object-oriented",
                            "Procedural",
                            "Static",
                            "Strong",
                            "Compiled",
                            "Windows",
                            "Linux",
                            "iOS",
                            "Android",
                            "Web Browser",
                            "Standalone executable",
                            "Backends",
                            "Cross-platform development",
                            "Frontends",
                            "Games",
                            "GUIs",
                            "Web development",
                            "Financial systems",
                            "Mobile",
                            "Scientific calculations"
                        ],
                        "last_touched_at": null,
                        "is_new": false,
                        "links": {
                            "self": "https://exercism.org/tracks/delphi",
                            "exercises": "https://exercism.org/tracks/delphi/exercises",
                            "concepts": "https://exercism.org/tracks/delphi/concepts"
                        }
                    }
            
            ]
            """
        return try! decoder().decode([Track].self, from: Data(data.utf8))
    }

    func getExercises() -> [Exercise] {
        let data = """
           [
        {
               "slug": "hello-world",
               "type": "tutorial",
               "title": "Hello World",
               "icon_url": "https://dg8krxphbh767.cloudfront.net/exercises/hello-world.svg",
               "difficulty": "easy",
               "blurb": "The classical introductory exercise. Just say Hello, World!.",
               "is_external": false,
               "is_unlocked": true,
               "is_recommended": true,
               "links": {
                 "self": "/tracks/awk/exercises/hello-world"
               }
             },
        {
               "slug": "hello-world",
               "type": "tutorial",
               "title": "Hello World",
               "icon_url": "https://dg8krxphbh767.cloudfront.net/exercises/hello-world.svg",
               "difficulty": "easy",
               "blurb": "The classical introductory exercise. Just say Hello, World!.",
               "is_external": false,
               "is_unlocked": false,
               "is_recommended": true,
               "links": {
                 "self": "/tracks/awk/exercises/hello-world"
               }
             }
        ]
        """
        return try! decoder().decode([Exercise].self, from: Data(data.utf8))
    }

    func getOrCreateDir(_ trackId: String, _ exerciseId: String) -> URL? {
        do {
            let docsFolder = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)

            let solutionDir = docsFolder
                .appendingPathComponent("\(trackId)/\(exerciseId)/", isDirectory: true)

            if !fileManager.fileExists(atPath: solutionDir.relativePath) {
                try fileManager.createDirectory(atPath: solutionDir.path, withIntermediateDirectories: true)
            }
            return solutionDir
        } catch {
            print("Error in the preview data: \(error)")
        }
        return nil
    }

    func getExerciseDoc(_ trackId: String, _ exerciseId: String) -> ExerciseDocument {
        let solutionFile = getSolutionFile()
        return try! ExerciseDocument(with: getOrCreateDir(trackId, exerciseId)!, solution: solutionFile.solution)
    }

    func getSolutions() -> [Solution] {
        let data = """
        [
        {
          "uuid": "bbf9b231b2a946ddbcd2db748e4c702c",
          "private_url": "https://exercism.org/tracks/swift/exercises/wings-quest",
          "public_url": "https://exercism.org/tracks/swift/exercises/wings-quest/solutions/cedricbahirwe",
          "status": "iterated",
          "mentoring_status": "none",
          "published_iteration_head_tests_status": "not_queued",
          "has_notifications": false,
          "num_views": 0,
          "num_stars": 0,
          "num_comments": 0,
          "num_iterations": 2,
          "num_loc": 12,
          "is_out_of_date": false,
          "published_at": null,
          "completed_at": null,
          "updated_at": "2024-01-10T13:36:28+00:00",
          "last_iterated_at": "2024-01-08T11:18:37+00:00",
          "exercise": {
            "slug": "wings-quest",
            "title": "Wings Quest",
            "icon_url": "https://assets.exercism.org/exercises/low-power-embedded-game.svg"
          },
          "track": {
            "slug": "swift",
            "title": "Swift",
            "icon_url": "https://assets.exercism.org/tracks/swift.svg"
          }
        }, 
         {
                    "uuid": "42d190e79ca74b918fde14bcd4ddf472",
                    "private_url": "https://exercism.org/tracks/groovy/exercises/hello-world",
                    "public_url": "https://exercism.org/tracks/groovy/exercises/hello-world/solutions/angiemugo",
                    "status": "started",
                    "mentoring_status": "none",
                    "published_iteration_head_tests_status": "not_queued",
                    "has_notifications": false,
                    "num_views": 0,
                    "num_stars": 0,
                    "num_comments": 0,
                    "num_iterations": 0,
                    "num_loc": null,
                    "is_out_of_date": false,
                    "published_at": null,
                    "completed_at": null,
                    "updated_at": "2024-06-12T19:55:34Z",
                    "last_iterated_at": null,
                    "exercise": {
                        "slug": "hello-world",
                        "title": "Hello World",
                        "icon_url": "https://assets.exercism.org/exercises/hello-world.svg"
                    },
                    "track": {
                        "slug": "groovy",
                        "title": "Groovy",
                        "icon_url": "https://assets.exercism.org/tracks/groovy.svg"
                    }
                },
                {
                    "uuid": "c0dec64e644840fc9d786517ecf81a85",
                    "private_url": "https://exercism.org/tracks/bash/exercises/two-fer",
                    "public_url": "https://exercism.org/tracks/bash/exercises/two-fer/solutions/angiemugo",
                    "status": "started",
                    "mentoring_status": "none",
                    "published_iteration_head_tests_status": "not_queued",
                    "has_notifications": false,
                    "num_views": 0,
                    "num_stars": 0,
                    "num_comments": 0,
                    "num_iterations": 0,
                    "num_loc": null,
                    "is_out_of_date": false,
                    "published_at": null,
                    "completed_at": null,
                    "updated_at": "2025-04-01T09:20:19Z",
                    "last_iterated_at": null,
                    "exercise": {
                        "slug": "two-fer",
                        "title": "Two Fer",
                        "icon_url": "https://assets.exercism.org/exercises/two-fer.svg"
                    },
                    "track": {
                        "slug": "bash",
                        "title": "Bash",
                        "icon_url": "https://assets.exercism.org/tracks/bash.svg"
                    }
                }
        ]
        """
        return try! decoder().decode([Solution].self, from: Data(data.utf8))
    }

    func getSolutionFile() -> SolutionResponse {
        let data = """
            {
                "solution": {
                    "id": "0c0fc9e088e0422db5d6abd2cd93d939",
                    "url": "https://exercism.org/tracks/swift/exercises/hello-world",
                    "user": {
                        "handle": "angiemugo",
                        "is_requester": true
                    },
                    "exercise": {
                        "id": "hello-world",
                        "instructions_url": "https://exercism.org/tracks/swift/exercises/hello-world",
                        "track": {
                            "id": "swift",
                            "language": "Swift"
                        }
                    },
                    "file_download_base_url": "https://exercism.org/api/v1/solutions/0c0fc9e088e0422db5d6abd2cd93d939/files/",
                    "files": [
                        ".exercism/config.json",
                        "README.md",
                        "HELP.md",
                        ".gitignore",
                        "Package.swift",
                        "Sources/HelloWorld/HelloWorld.swift",
                        "Tests/HelloWorldTests/HelloWorldTests.swift"
                    ],
                    "submission": {
                        "submitted_at": "2025-03-17T12:27:28.267Z"
                    }
                }
            }
            """
        return try! decoder().decode(SolutionResponse.self, from: Data(data.utf8))
    }

    func getInitialFile() -> InitialFiles {
        let data = """
        {
            "files": [
                {
                    "filename": "Sources/HelloWorld/HelloWorld.swift",
                    "type": "exercise",
                    "digest": null,
                    "content": "func hello() -> String {"
                }
            ]
        }
        """

        return try! decoder().decode(InitialFiles.self, from: Data(data.utf8))
    }

    func getIteration() -> IterationResponse {
        let data = """
        {
            "iterations": [
                {
                    "uuid": "b5bcd8384bf74d9a88eb72be93a2a609",
                    "submission_uuid": "04960e71c9394c0093d44c8c2d1ed391",
                    "idx": 1,
                    "status": "no_automated_feedback",
                    "num_essential_automated_comments": 0,
                    "num_actionable_automated_comments": 0,
                    "num_non_actionable_automated_comments": 0,
                    "num_celebratory_automated_comments": 0,
                    "submission_method": "api",
                    "created_at": "2023-08-09T17:37:03Z",
                    "tests_status": "passed",
                    "is_published": true,
                    "is_latest": false,
                    "links": {
                        "self": "https://exercism.org/tracks/swift/exercises/lasagna/iterations?idx=1",
                        "automated_feedback": "https://exercism.org/api/v2/solutions/8e9853808a1e4cceb9431927aa0d3d4a/iterations/b5bcd8384bf74d9a88eb72be93a2a609/automated_feedback",
                        "delete": "https://exercism.org/api/v2/solutions/8e9853808a1e4cceb9431927aa0d3d4a/iterations/b5bcd8384bf74d9a88eb72be93a2a609",
                        "solution": "https://exercism.org/tracks/swift/exercises/lasagna",
                        "test_run": "https://exercism.org/api/v2/solutions/8e9853808a1e4cceb9431927aa0d3d4a/submissions/04960e71c9394c0093d44c8c2d1ed391/test_run",
                        "files": "https://exercism.org/api/v2/solutions/8e9853808a1e4cceb9431927aa0d3d4a/submissions/04960e71c9394c0093d44c8c2d1ed391/files"
                    }
                }
            ]
        }
        """
        return try! decoder().decode(IterationResponse.self, from: Data(data.utf8))
    }


    func getTestPass() -> TestRunResponse {
        let data = """
        {
            "test_run": {
                "uuid": "5a84b970-22b7-4d52-acb2-b344988c9147",
                "submission_uuid": "188c56d0b9a54010bcad2117c197bcce",
                "version": 3,
                "status": "pass",
                "message": null,
                "message_html": null,
                "output": null,
                "output_html": null,
                "tests": [
                    {
                        "name": "testBirthday",
                        "status": "pass",
                        "test_code": "XCTAssertEqual(birthday, \\\"Birthday\\\")",
                        "message": null,
                        "message_html": null,
                        "expected": null,
                        "output": null,
                        "output_html": null,
                        "task_id": 1
                    }
                ],
                "tasks": [
                    { "id": 1, "title": "Create a set of useful strings" },
                    { "id": 2, "title": "Create a set of useful characters" },
                    { "id": 3, "title": "Combine phrases to build up messages" },
                    { "id": 4, "title": "Build a graduation sign" },
                    { "id": 5, "title": "Compute the cost of a sign" }
                ],
                "highlightjs_language": "swift",
                "links": {
                    "self": "https://exercism.org/api/v2/solutions/a6fabf1433f84c31bb80f9ee4c015e3f/submissions/188c56d0b9a54010bcad2117c197bcce/test_run"
                }
            },
            "test_runner": {
                "average_test_duration": 10,
                "status": {
                    "exercise": true,
                    "track": true
                }
            }
        }
        """
        return try! decoder().decode(TestRunResponse.self, from: Data(data.utf8))
    }

    func runTest() -> TestSubmission {
        let data = """
    {
        "submission": {
            "uuid": "c99fde0cdba7417e82210ecada8a7860",
            "tests_status": "queued",
            "links": {
                "cancel": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/test_run/cancel",
                "submit": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/iterations?submission_uuid=c99fde0cdba7417e82210ecada8a7860",
                "test_run": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/test_run",
                "ai_help": "/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/ai_help",
                "initial_files": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/initial_files",
                "last_iteration_files": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/last_iteration_files"
            }
        }
    }
    """
        return try! decoder().decode(TestSubmission.self, from: Data(data.utf8))
    }

    func getSubmissionResponse() -> SubmitSolutionResponse {
        let data = """
            {
                "iteration": {
                    "uuid": "e411d428bc324462aab844f2d80adca1",
                    "submission_uuid": "c99fde0cdba7417e82210ecada8a7860",
                    "idx": 1,
                    "status": "tests_failed",
                    "num_essential_automated_comments": 0,
                    "num_actionable_automated_comments": 0,
                    "num_non_actionable_automated_comments": 0,
                    "num_celebratory_automated_comments": 0,
                    "submission_method": "api",
                    "created_at": "2025-05-18T12:32:04Z",
                    "tests_status": "errored",
                    "is_published": false,
                    "is_latest": true,
                    "links": {
                        "self": "https://exercism.org/tracks/swift/exercises/leap/iterations?idx=1",
                        "automated_feedback": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/iterations/e411d428bc324462aab844f2d80adca1/automated_feedback",
                        "delete": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/iterations/e411d428bc324462aab844f2d80adca1",
                        "solution": "https://exercism.org/tracks/swift/exercises/leap",
                        "test_run": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/test_run",
                        "files": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/files"
                    }
                }
            }
            """
        return try! decoder().decode(SubmitSolutionResponse.self, from: Data(data.utf8))
    }

    func getSubmissionSuccess() -> SubmitSolutionResponse {
        let data = """
            {
                "iteration": {
                    "uuid": "e411d428bc324462aab844f2d80adca1",
                    "submission_uuid": "c99fde0cdba7417e82210ecada8a7860",
                    "idx": 1,
                    "status": "tests_failed",
                    "num_essential_automated_comments": 0,
                    "num_actionable_automated_comments": 0,
                    "num_non_actionable_automated_comments": 0,
                    "num_celebratory_automated_comments": 0,
                    "submission_method": "api",
                    "created_at": "2025-05-18T12:32:04Z",
                    "tests_status": "passed",
                    "is_published": false,
                    "is_latest": true,
                    "links": {
                        "self": "https://exercism.org/tracks/swift/exercises/leap/iterations?idx=1",
                        "automated_feedback": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/iterations/e411d428bc324462aab844f2d80adca1/automated_feedback",
                        "delete": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/iterations/e411d428bc324462aab844f2d80adca1",
                        "solution": "https://exercism.org/tracks/swift/exercises/leap",
                        "test_run": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/test_run",
                        "files": "https://exercism.org/api/v2/solutions/e026ab07640644dcb46f82368aac1b39/submissions/c99fde0cdba7417e82210ecada8a7860/files"
                    }
                }
            }
            """
        return try! decoder().decode(SubmitSolutionResponse.self, from: Data(data.utf8))
    }
}

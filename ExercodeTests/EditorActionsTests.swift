//
//  EditorActionsTests.swift
//  Exercism
//
//  Created by Angie Mugo on 18/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class EditorActionsTests: XCTestCase {
    private var fetcher: MockFetcher!
    private var client: MockExercismClient!
    private var viewModel: EditorActionsViewModel!

    override func setUp() async throws {
        try await super.setUp()
        let exerciseItem = getExerciseItem()
        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        viewModel = EditorActionsViewModel(fetcher: fetcher,
                                           solutionUUID: "",
                                           exerciseItem: exerciseItem,
                                           iterations: [])
    }

    override func tearDown() async throws {
        client = nil
        fetcher = nil
        viewModel = nil
        try await super.tearDown()
    }

    private func getExerciseItem() -> ExerciseItem {
        let doc = PreviewData.shared.getExerciseDoc("Swift", "Hello-world")
        let file = ExerciseFile(from: doc.solutions.first!)
        return ExerciseItem(name: doc.solution.exercise.trackId,
                            language: doc.solution.exercise.trackLanguage, files: [file])
    }

    private func getMockIteration() -> IterationResponse {
        PreviewData.shared.getIteration()
    }

    private func getMockTestRunPassed() -> TestRunResponse {
        PreviewData.shared.getTestPass()
    }

    private func getSubmissionResponse() -> SubmitSolutionResponse {
        PreviewData.shared.getSubmissionResponse()
    }

    private func mockRunTest() -> TestSubmission {
        PreviewData.shared.runTest()
    }

    func testRunTestsQueued() async {
        let runTest = mockRunTest()
        let testRun = getMockTestRunPassed()

        client.onRunTest = { _, _ in
            return runTest
        }

        client.onGetTestRun = { _ in
            return testRun
        }

        await viewModel.runTests()

        guard case .testRunSuccess(_, let test) = viewModel.state else {
            XCTFail("Expected .success state, got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(test.status, testRun.testRun!.status)
        XCTAssertTrue(viewModel.canSubmitSolution)
        XCTAssertEqual(viewModel.selectedTab, SelectedTab.result)
        XCTAssertTrue(viewModel.canRunTests)
    }

    func testRunTestsError() async {
        let error = ExercismClientError.apiError(code: .genericError, type: "", message: "")
        client.onRunTest = { _, _ throws(ExercismClientError) in
            throw error
        }

        await viewModel.runTests()

        guard case .actionErrored(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state, got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(returnedError.description, error.description)
        XCTAssertEqual(viewModel.selectedTab, SelectedTab.result)
        XCTAssertTrue(viewModel.canRunTests)
        XCTAssertTrue(viewModel.showErrorAlert)
    }

    func testWrongSubmitSolution() async {
        let runTest = mockRunTest()
        let testRun = getMockTestRunPassed()
        let submitResponse = getSubmissionResponse()

        viewModel.state = .testRunSuccess(runTest.links, testRun.testRun!)

        client.onSubmitSolution = { _ in
            return submitResponse
        }

        await viewModel.submitSolution()

        guard case .submitWrongSolution = viewModel.state else {
            XCTFail("Expected .submitWrongSolution state, got: \(viewModel.state)")
            return
        }
    }

    func testSubmitSuccess() async {
        let runTest = mockRunTest()
        let testRun = getMockTestRunPassed()
        let submitResponse = getSubmissionResponse()

        viewModel.state = .testRunSuccess(runTest.links, testRun.testRun!)

        client.onSubmitSolution = { _ in
            return submitResponse
        }

        await viewModel.submitSolution()

        guard case .submitWrongSolution = viewModel.state else {
            XCTFail("Expected .submitWrongSolution state, got: \(viewModel.state)")
            return
        }
    }

    func testComplete() async {
        // You can implement this test similarly by mocking client.onCompleteSolution
    }

    func testRevertToStart() async {
        let initialFiles = PreviewData.shared.getInitialFile()

        client.onInitialSolution = { _ in
            return initialFiles
        }

        let newInit = await viewModel.revertToStart()

        XCTAssertEqual(newInit, initialFiles.files.first?.content)
    }

    func testRevertError() async {
        let error = ExercismClientError.apiError(code: .genericError, type: "", message: "")
        client.onInitialSolution = { _ throws(ExercismClientError) in
            throw error
        }

        _ = await viewModel.revertToStart()

        guard case .actionErrored(let returnedError) = viewModel.state else {
            XCTFail("Expected .actionErrored state, got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(returnedError.description, error.description)
        XCTAssertTrue(viewModel.showErrorAlert)
    }
}

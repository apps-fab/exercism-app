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
        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        viewModel = EditorActionsViewModel(solutionUUID: "", exerciseItem: nil, iterations: [])
    }

    override func tearDown() async throws {
        client = nil
        fetcher = nil
        viewModel = nil
        try await super.tearDown()
    }

    func getMockIteration() -> IterationResponse {
        PreviewData.shared.getIteration()
    }

    func getMockTestRunPassed() -> TestRunResponse {
        PreviewData.shared.getTestPass()
    }

    func getSubmissionResponse() -> SubmitSolutionResponse {
        PreviewData.shared.getSubmissionResponse()
    }

    func testRunTestsPassed() async {
        viewModel.solutionUUID = "mock-id"
        let testRun = getMockTestRunPassed()

        client.onGetTestRun = { _, completion in
            completion(.success(testRun))
        }

        await viewModel.runTests()

        guard case .testRunSuccess(_, let test) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        XCTAssertEqual(test.status, testRun.testRun!.status)
        XCTAssertTrue(viewModel.canSubmitSolution)
        XCTAssertTrue(viewModel.canRunTests)
    }

    func testRunTestsError() async {
        let error = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")
        viewModel.solutionUUID = "mock-id"
        let testRun = getMockTestRunPassed()

        client.onGetTestRun = { _, completion in
            completion(.failure(error))
        }

        await viewModel.runTests()
        guard case .actionErrored(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state")
            return
        }
        XCTAssertEqual(error.description, returnedError.description)
        XCTAssertTrue(viewModel.canRunTests)
        XCTAssertTrue(viewModel.showErrorAlert)
    }

    func testSubmitSolution() async {
        viewModel.solutionUUID = "mock-id"
        let submitResponse = getSubmissionResponse()

        client.onSubmitSolution = { _, completion in
            completion(.success(submitResponse))
        }

        await viewModel.submitSolution()

        guard case .submitSuccess(let response) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        XCTAssertEqual(response, submitResponse.iteration.submissionUuid)
    }
}

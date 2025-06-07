//
//  ExerciseEditorTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class ExerciseViewModelTests: XCTestCase {
    private var fetcher: MockFetcher!
    private var client: MockExercismClient!
    private var viewModel: ExerciseViewModel!

    override func setUp() async throws {
        try await super.setUp()
        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        viewModel = ExerciseViewModel("swift", "hello-world", fetcher)
    }

    override func tearDown() async throws {
        client = nil
        fetcher = nil
        viewModel = nil
        try await super.tearDown()
    }

    func getMockDoc() -> ExerciseDocument {
        PreviewData.shared.getExerciseDoc("swift", "hello-world")
    }

    private func getMockIteration() -> IterationResponse {
        PreviewData.shared.getIteration()
    }

    func testGetDocSuccess() async {
        let mockDoc = getMockDoc()
        let iterations = getMockIteration()

        client.onDownloadSolution = { _, _, completion in
            completion(.success(mockDoc))
        }

        client.onGetIterations = { _, completion in
            completion(.success(iterations))
        }

        await viewModel.getDocument()

        let expectation = XCTestExpectation(description: "Wait for .success state")

        for _ in 0..<50 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            if case .success = viewModel.state {
                expectation.fulfill()
                break
            }
        }

        await fulfillment(of: [expectation], timeout: 5)

        guard case .success(let returnedDoc) = viewModel.state else {
            XCTFail("Expected .success state, got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(viewModel.title, returnedDoc.0.first?.title)
        XCTAssertEqual(viewModel.solutionUUID, "0c0fc9e088e0422db5d6abd2cd93d939")
        XCTAssertEqual(viewModel.language, "Swift")
        XCTAssertEqual(viewModel.selectedFile.id, "Sources/HelloWorld/HelloWorld.swift")
        XCTAssertFalse(viewModel.selectedCode.isEmpty)
        XCTAssertFalse(((viewModel.instruction?.isEmpty) == nil))
        XCTAssertFalse(((viewModel.tests?.isEmpty) == nil))
    }

    func testGetDocFailure() async {
        let error = ExercismClientError.apiError(code: .genericError, type: "", message: "")

        client.onDownloadSolution = { _, _, completion in
            completion(.failure(error))
        }

        client.onGetIterations = { _, completion in
            completion(.failure(error))
        }

        await viewModel.getDocument()

        let expectation = XCTestExpectation(description: "Wait for .failure state")

        for _ in 0..<50 {
            try? await Task.sleep(nanoseconds: 100_000_000)
            if case .failure = viewModel.state {
                expectation.fulfill()
                break
            }
        }

        await fulfillment(of: [expectation], timeout: 5)

        guard case .failure(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state, got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(error.description, returnedError.description)
        XCTAssertNil(viewModel.solutionUUID)
        XCTAssertNil(viewModel.language)
        XCTAssertNil(viewModel.instruction)
        XCTAssertNil(viewModel.tests)
        XCTAssertNil(viewModel.selectedFile)
    }

    func testUpdateFileReturnsFalseWhenCodeIsEmpty() {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("Test.swift")
        let tempFile = ExerciseFile(from: fileURL)
        viewModel.selectedFile = tempFile
        viewModel.selectedCode = ""

        let result = viewModel.updateFile()

        XCTAssertFalse(result)
    }

    func testUpdateFileReturnsFalseWhenWriteFails() {
        let invalidURL = URL(fileURLWithPath: "/root/invalid.swift")
        let tempFile = ExerciseFile(from: invalidURL)
        viewModel.selectedFile = tempFile
        viewModel.selectedCode = "print(\"fail\")"

        let result = viewModel.updateFile()

        XCTAssertFalse(result)
    }

    func testUpdateFileSuccess() {
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let tempFile = ExerciseFile(from: fileURL)
        viewModel.selectedFile = tempFile
        viewModel.selectedCode = "print(\"Hello\")"

        let result = viewModel.updateFile()
        XCTAssertTrue(result)

        let contents = try? String(contentsOf: fileURL, encoding: .utf8)
        XCTAssertEqual(contents, viewModel.selectedCode)
    }
}

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

    func getMockInitial() -> InitialFiles {
        PreviewData.shared.getInitialFile()
    }

    func testGetDocumentSuccess() async {
        let mockDoc = getMockDoc()

        client.onDownloadSolution = { _, _, completion in
            completion(.success(mockDoc))
        }
        viewModel = ExerciseViewModel("swift", "hello-world", fetcher)

        try? await Task.sleep(nanoseconds: 500_000_000)
        guard case .success(let returnedDoc) = viewModel.state else {
            return
        }

        XCTAssertEqual(viewModel.title, returnedDoc.0.first?.title)
        XCTAssertNotNil(viewModel.solutionUUID)
        XCTAssertNotNil(viewModel.language)
        XCTAssertNotNil(viewModel.instruction)
        XCTAssertNotNil(viewModel.tests)
        XCTAssertNotNil(viewModel.selectedFile)
        XCTAssertNotNil(viewModel.selectedCode)
    }

    func testGetLanguage() {
        let mockDoc = getMockDoc()

        viewModel.getLanguage(mockDoc)
        XCTAssertEqual(viewModel.language, mockDoc.solution.exercise.trackLanguage)
    }

    func testGetInstruction() {
        let mockDoc = getMockDoc()
        guard let instructions = mockDoc.instructions,
              let instructions = try? String(contentsOf: instructions, encoding: .utf8) else {
            XCTAssert(false, "Mock data is missing instructions")
            return
        }
        try? viewModel.getExerciseInstructions(mockDoc)

        XCTAssertEqual(viewModel.instruction, instructions)
    }

    func testGetTests() {
        let mockDoc = getMockDoc()
        guard let tests = mockDoc.tests.first,
              let tests = try? String(contentsOf: tests, encoding: .utf8) else {
            XCTAssert(false, "Mock data is missing tests")
            return
        }
        try? viewModel.getExerciseTests(mockDoc)

        XCTAssertEqual(viewModel.tests, tests)
    }

    func testGetSelectedCode() {
        let mockDoc = getMockDoc()
        guard let exerciseFile = viewModel.createExerciseFile(from: mockDoc).first else {
            XCTAssert(false, "Exercise file not created")
            return
        }
        let selectedCode = viewModel.getSelectedCode(for: exerciseFile)
        XCTAssertEqual(selectedCode, viewModel.selectedCode)
    }

    //    func testGetIterations() async {
    //        let iteration = getMockIteration()
    //
    //        client.onGetIterations = { _, completion in
    //            completion(.success(iteration))
    //        }
    //
    //        await viewModel.getIterations(for: "")
    //        XCTAssertEqual(viewModel.currentSolutionIterations.count, iteration.iterations.count)
    //    }

    func testGetDocumentFailure() async {
        let error = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")

        client.onDownloadSolution = { _, _, completion in
            completion(.failure(error))
        }

        viewModel = ExerciseViewModel("swift", "hello-world", fetcher)

        try? await Task.sleep(nanoseconds: 500_000_000)

        guard case .failure(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state but got: \(viewModel.state)")
            return
        }

        XCTAssertEqual(returnedError.localizedDescription, error.localizedDescription)
    }

    func testRevertToStartSuccess() async {
        viewModel.solutionUUID = "mock-id"

        let mockDoc = getMockDoc()
        client.onDownloadSolution = { _, _, completion in
            completion(.success(mockDoc))
        }

        let initialFiles = getMockInitial()
        client.onInitialSolution = { _, completion in
            completion(.success(initialFiles))
        }

        await viewModel.revertToStart()

        XCTAssertEqual(viewModel.selectedCode, initialFiles.files.first?.content)
    }
}

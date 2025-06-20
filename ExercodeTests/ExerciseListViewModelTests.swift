//
//  ExerciseListViewModelTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class ExerciseListViewModelTests: XCTestCase {
    private var client: MockExercismClient!
    private var viewModel: ExerciseListViewModel!
    private var fetcher: MockFetcher!
    private var mockTrack: Track!

    private func loadTracks() -> [Track] {
        return PreviewData.shared.getTracks()
    }

    private func loadExercises() -> [Exercise] {
        return PreviewData.shared.getExercises()
    }

    private func loadSolutions() -> [Solution] {
        return PreviewData.shared.getSolutions()
    }

    // MARK: - Setup & Teardown

    override func setUp() async throws {
        try await super.setUp()

        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        mockTrack = loadTracks()[0]
        viewModel = ExerciseListViewModel(mockTrack, fetcher)
    }

    override func tearDown() async throws {
        viewModel = nil
        client = nil
        mockTrack = nil
        fetcher = nil

        try await super.tearDown()
    }

    // MARK: - Tests

    func testGetExercisesSuccess() async {
        let mockExercises = loadExercises()
        client.onExercises = { _ in
            return ListResponse(results: mockExercises)
        }

        await viewModel.getExercises()

        guard case .success(let exercises) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        XCTAssertEqual(exercises.count, 2)
        XCTAssertEqual(exercises.first?.slug, "hello-world")
    }

    func testGetExercisesFailure() async {
        let expectedError = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")
        client.onExercises = { _ throws(ExercismClientError) in
            throw expectedError
        }

        await viewModel.getExercises()

        guard case .failure(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state")
            return
        }

        XCTAssertEqual(returnedError, expectedError.description)
    }

    func testFilterExercises() async {
        let mockExercises = loadExercises()
        client.onExercises = { _ in
            return ListResponse(results: mockExercises)
        }

        await viewModel.getExercises()
        viewModel.filterExercises("he")

        guard case .success(let filtered) = viewModel.state else {
            XCTFail("Expected .success state"); return
        }

        XCTAssertTrue(filtered.map { $0.slug }.contains("hello-world"))
    }

    func testGroupExercisesByCategory() async throws {
        let exercises = loadExercises()
        let solutions = loadSolutions()

        client.onExercises = { _ in
            return ListResponse(results: exercises)
        }

        client.onSolutions = { _, _, _ in
            return ListResponse(results: solutions)
        }

        try await viewModel.getSolutions()

        XCTAssertEqual(viewModel.solutions.count, 3)

        let grouped = viewModel.groupExercises(exercises)
        XCTAssertEqual(grouped[.completed]?.count, 0)
        XCTAssertEqual(grouped[.inProgress]?.count, 2)
        XCTAssertEqual(grouped[.locked]?.count, 1)
        XCTAssertEqual(grouped[.available]?.count, 0)
    }
}

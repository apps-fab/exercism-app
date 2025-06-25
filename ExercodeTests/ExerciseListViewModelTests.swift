//
//  ExerciseListViewModelTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
import Combine
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class ExerciseListViewModelTests: XCTestCase {
    private var client: MockExercismClient!
    private var viewModel: ExerciseListViewModel!
    private var fetcher: MockFetcher!
    private var mockTrack: Track!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers

    private func loadTracks() -> [Track] { PreviewData.shared.getTracks() }
    private func loadExercises() -> [Exercise] { PreviewData.shared.getExercises() }
    private func loadSolutions() -> [Solution] { PreviewData.shared.getSolutions() }

    private func stubClient(exercises: [Exercise], solutions: [Solution]) {
        client.onExercises = { _ in ListResponse(results: exercises) }
        client.onSolutions = { _, _, _ in ListResponse(results: solutions) }
    }

    // MARK: - Setup / Teardown

    override func setUp() async throws {
        try await super.setUp()
        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        mockTrack = loadTracks().first!
        viewModel = ExerciseListViewModel(mockTrack, fetcher)
    }

    override func tearDown() async throws {
        viewModel = nil
        client = nil
        mockTrack = nil
        fetcher = nil
        cancellables.removeAll()
        try await super.tearDown()
    }

    // MARK: - Tests

    func testLoadSuccess() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        guard case .success = viewModel.state else {
            return XCTFail("Expected success state")
        }

        XCTAssertEqual(viewModel.solutions.count, solutions.count)
        XCTAssertFalse(viewModel.filteredGroupedExercises.isEmpty)
        XCTAssertEqual(viewModel.selectedCategory, .allExercises)
    }

    func testLoadFailure() async {
        let expectedError = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")
        client.onExercises = { _ throws(ExercismClientError) in throw expectedError }

        await viewModel.loadData()

        guard case .failure(let error) = viewModel.state else {
            return XCTFail("Expected failure state")
        }
        XCTAssertEqual(error, expectedError.description)
    }

    func testGetSolution() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        let exerciseWithSolution = exercises[0]
        let solution = viewModel.getSolution(for: exerciseWithSolution)

        XCTAssertNotNil(solution)
        XCTAssertEqual(solution?.exercise.slug, exerciseWithSolution.slug)
        XCTAssertNil(viewModel.getSolution(for: exercises[1]))
    }

    func testExerciseGrouping() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        let grouped = viewModel.filteredGroupedExercises

        XCTAssertEqual(Set(grouped.keys), Set(ExerciseCategory.allCases))
        XCTAssertEqual(grouped[.allExercises]?.count, exercises.count)

        let completedCount = grouped[.completed]?.count ?? 0
        let expectedCompletedCount = exercises.filter { exercise in
            viewModel.getSolution(for: exercise)?.isCompleted ?? false
        }.count
        XCTAssertEqual(completedCount, expectedCompletedCount)

        let inProgressCount = grouped[.inProgress]?.count ?? 0
        let expectedInProgressCount = exercises.filter { exercise in
            viewModel.getSolution(for: exercise)?.isInProgress ?? false
        }.count
        XCTAssertEqual(inProgressCount, expectedInProgressCount)
    }

    func testEmptySearch() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        viewModel.searchText = ""
        try? await Task.sleep(nanoseconds: 400_000_000)

        guard case .success(let filtered) = viewModel.state else {
            return XCTFail("Expected success state")
        }

        XCTAssertEqual(filtered, exercises)
    }

    func testFilter() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        viewModel.searchText = "hello"
        try? await Task.sleep(nanoseconds: 400_000_000)

        guard case .success(let filtered) = viewModel.state else {
            return XCTFail("Expected success state")
        }

        XCTAssertFalse(filtered.isEmpty)
        XCTAssertTrue(filtered.allSatisfy {
            $0.slug.lowercased().contains("hello") || $0.title.lowercased().contains("hello")
        })

        for (category, exercises) in viewModel.filteredGroupedExercises {
            XCTAssertTrue(exercises.allSatisfy {
                $0.slug.lowercased().contains("hello") || $0.title.lowercased().contains("hello")
            }, "Category \(category) not properly filtered")
        }
    }

    func testSelectedCategory() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        viewModel.searchText = ""
        viewModel.selectedCategory = .completed
        try? await Task.sleep(nanoseconds: 400_000_000)

        guard case .success(let filtered) = viewModel.state else {
            return XCTFail("Expected success state")
        }

        XCTAssertEqual(filtered, viewModel.filteredGroupedExercises[.completed])

        viewModel.selectedCategory = .inProgress
        try? await Task.sleep(nanoseconds: 400_000_000)

        guard case .success(let filtered2) = viewModel.state else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(filtered2, viewModel.filteredGroupedExercises[.inProgress])
    }

    func testDebounceCombinedSearchAndCategoryChanges() async {
        let exercises = loadExercises()
        let solutions = loadSolutions()
        stubClient(exercises: exercises, solutions: solutions)

        await viewModel.loadData()

        var receivedStates = [LoadingState<[Exercise]>]()
        let expectation = XCTestExpectation(description: "Receive debounced state updates")

        viewModel.$state
            .dropFirst()
            .sink { state in
                receivedStates.append(state)
                if receivedStates.count >= 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.searchText = "h"
        viewModel.searchText = "he"
        viewModel.searchText = "hel"
        viewModel.selectedCategory = .completed
        viewModel.searchText = "hello"

        await fulfillment(of: [expectation], timeout: 2)

        XCTAssertTrue(receivedStates.contains { state in
            if case .success = state { return true }
            return false
        })
    }
}

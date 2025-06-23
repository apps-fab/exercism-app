//
//  TrackViewModelTests.swift
//  Exercism
//
//  Created by Angie Mugo on 13/05/2025.
//

import XCTest
@testable import Exercode
@testable import ExercismSwift

@MainActor
final class TrackViewModelTests: XCTestCase {
    // MARK: - Properties
    private var client: MockExercismClient!
    private var fetcher: MockFetcher!
    private var viewModel: TrackViewModel!

    // MARK: - Helpers

    private func loadTracks() -> [Track] {
        PreviewData.shared.getTracks()
    }

    // MARK: - Setup & Teardown

    override func setUp() async throws {
        try await super.setUp()

        client = MockExercismClient()
        fetcher = MockFetcher(client: client)
        viewModel = TrackViewModel(fetcher: fetcher)
    }

    override func tearDown() async throws {
        client = nil
        fetcher = nil
        viewModel = nil

        try await super.tearDown()
    }

    // MARK: - Tests

    func testLoadSuccess() async {
        let mockTracks = loadTracks()
        client.onTracks = {
            return ListResponse(results: mockTracks)
        }

        await viewModel.loadTracks()

        guard case .success(let tracks) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        XCTAssertEqual(tracks.count, 2)
        XCTAssertEqual(tracks.first?.title, "AWK")
    }

    func testLoadFailure() async {
        let error = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")
        client.onTracks = { () throws(ExercismClientError) in
            throw error
        }

        await viewModel.loadTracks()

        guard case .failure(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state")
            return
        }

        XCTAssertEqual(returnedError, error.description)
    }

    func testFilterTracks() async {
        let mockTracks = loadTracks()
        client.onTracks = {
            return ListResponse(results: mockTracks)
        }

        await viewModel.loadTracks()
        viewModel.searchText = "de"

        guard case .success(let filtered) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        XCTAssertTrue(filtered.map { $0.slug }.contains("delphi"))
    }

    func testTags() async {
        let mockTracks = loadTracks()
        client.onTracks = {
            return ListResponse(results: mockTracks)
        }

        await viewModel.loadTracks()
        viewModel.selectedTags = ["Compiled"]

        guard case .success(let filteredTracks) = viewModel.state else {
            XCTFail("Expected .success state but got \(viewModel.state)")
            return
        }

        XCTAssertFalse(filteredTracks.isEmpty, "Expected at least one track with 'compiled' tag")

        for track in filteredTracks {
            XCTAssertTrue(
                track.tags.contains("Compiled"),
                "Track \(track.slug) does not contain the 'compiled' tag"
            )
        }
    }

    func testSort() async {
        let mockTracks = loadTracks()
        client.onTracks = {
            return ListResponse(results: mockTracks)
        }

        await viewModel.loadTracks()
        viewModel.sortTracks()

        guard case .success(let sorted) = viewModel.state else {
            XCTFail("Expected .success state")
            return
        }

        let dates = sorted.compactMap(\.lastTouchedAt)
        let isSortedDescending = dates == dates.sorted(by: >)
        XCTAssertTrue(isSortedDescending, "Tracks are not sorted by lastTouchedAt descending")
    }
}

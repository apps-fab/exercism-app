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

    func testGetTracksSuccess() async {
        let mockTracks = loadTracks()
        client.onTracks = { completion in
            completion(.success(ListResponse(results: mockTracks)))
        }

        await viewModel.getTracks()

        guard case .success(let tracks) = viewModel.state else {
            XCTFail("Expected .success state"); return
        }

        XCTAssertEqual(tracks.count, 2)
        XCTAssertEqual(tracks.first?.title, "AWK")
    }

    func testGetTracksFailure() async {
        let error = ExercismClientError.apiError(code: .unauthorized, type: "", message: "")
        client.onTracks = { completion in
            completion(.failure(error))
        }

        await viewModel.getTracks()

        guard case .failure(let returnedError) = viewModel.state else {
            XCTFail("Expected .failure state"); return
        }

        XCTAssertEqual(returnedError.localizedDescription, error.localizedDescription)
    }

    func testFilterTracks() async {
        let mockTracks = loadTracks()
        client.onTracks = { completion in
            completion(.success(ListResponse(results: mockTracks)))
        }

        await viewModel.getTracks()
        viewModel.filterTracks("de")

        guard case .success(let filtered) = viewModel.state else {
            XCTFail("Expected .success state"); return
        }

        XCTAssertTrue(filtered.map { $0.slug }.contains( "delphi"))
    }

    func testTags() async {
        let mockTracks = loadTracks()
        client.onTracks = { completion in
            completion(.success(ListResponse(results: mockTracks)))
        }

        await viewModel.getTracks()
        viewModel.filterTags(["Compiled"])

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

    func test_sortTracks_sortsByLastTouchedAtDescending() async {
        let mockTracks = loadTracks()
        client.onTracks = { completion in
            completion(.success(ListResponse(results: mockTracks)))
        }

        await viewModel.getTracks()
        viewModel.sortTracks()

        guard case .success(let sorted) = viewModel.state else {
            XCTFail("Expected .success state"); return
        }

        let dates = sorted.compactMap(\.lastTouchedAt)
        let isSortedDescending = dates == dates.sorted(by: >)
        XCTAssertTrue(isSortedDescending, "Tracks are not sorted by lastTouchedAt descending")
    }
}

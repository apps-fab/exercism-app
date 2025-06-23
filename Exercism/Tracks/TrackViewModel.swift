//
//  TrackViewModel.swift
//  Exercism
//
//  Created by Angie Mugo on 06/03/2023.
//

import ExercismSwift
import Foundation
import Combine

@MainActor
final class TrackViewModel: ObservableObject {
    @Published var state: LoadingState<[Track]> = .idle
    @Published var searchText: String = ""
    @Published var selectedTags = Set<String>()

    private var allTracks = [Track]()
    private let fetcher: FetchingProtocol
    private var cancellables = Set<AnyCancellable>()

    init(fetcher: FetchingProtocol? = nil) {
        self.fetcher = fetcher ?? Fetcher()
        setupListeners()
    }

    private func setupListeners() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterBySearchText(query)
            }.store(in: &cancellables)

        $selectedTags.removeDuplicates()
            .sink { [weak self] tags in
                self?.filterByTags(tags)
            }.store(in: &cancellables)
    }

    func loadTracks() async {
        state = .loading
        do {
            let fetchedTracks = try await fetcher.getTracks()
            allTracks = fetchedTracks
            state = .success(fetchedTracks)
        } catch {
            state = .failure(error.description)
        }
    }

    func sortTracks() {
        guard case .success(let current) = state else { return }

        let sorted = current.sorted {
            ($0.lastTouchedAt ?? .distantPast) > ($1.lastTouchedAt ?? .distantPast)
        }

        state = .success(sorted)
    }

    private func filterBySearchText(_ query: String) {
        guard !query.isEmpty else {
            state = .success(allTracks)
            return
        }
        let filtered = allTracks.filter { $0.title.lowercased().contains(query.lowercased()) }
        state = .success(filtered)
    }

    private func filterByTags(_ tags: Set<String>) {
        guard !tags.isEmpty else {
            state = .success(allTracks)
            return
        }
        let filtered = allTracks.filter { !Set($0.tags).isDisjoint(with: tags) }
        state = .success(filtered)
    }
}

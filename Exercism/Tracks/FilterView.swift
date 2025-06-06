//
//  FilterView.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

import SwiftUI
import ExercismSwift

struct FilterView: View {
    @State private var showingSheet = false
    @FocusState private var fieldFocused: Bool
    @Binding var searchText: String
    @Binding var filters: Set<String>
    var results: Int
    var sortAction: () -> Void

    var body: some View {
        HStack {
            searchField
            filterButton
            resultCountLabel
            sortButton
        }
        .onAppear {
            fieldFocused = false
        }
    }

    @ViewBuilder
    private var searchField: some View {
        HStack(spacing: 12) {
            Image.magnifyingGlass
                .imageScale(.large)

            TextField(Strings.searchTrackString.localized(), text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding(8)
        .roundEdges(lineColor: fieldFocused ? .appAccent : .gray, cornerRadius: 8)
        .focused($fieldFocused)
    }

    @ViewBuilder
    private var filterButton: some View {
        Button {
            showingSheet.toggle()
        } label: {
            Label {
                Text(Strings.filterBy.localized())
            } icon: {
                Image.slider
            }
            .padding(8)
            .roundEdges(lineColor: showingSheet ? .appAccent : .gray, cornerRadius: 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showingSheet) {
            FilterTableView(selectedTags: $filters, isPresented: $showingSheet)
                .interactiveDismissDisabled(false)
        }
    }

    @ViewBuilder
    private var resultCountLabel: some View {
        Text(String(format: Strings.showingTracks.localized(), results))
            .fontWeight(.semibold)
            .minimumScaleFactor(0.9)
            .lineLimit(1)
            .padding(8)
            .roundEdges(backgroundColor: Color.appAccent.opacity(0.5),
                        lineColor: .clear,
                        cornerRadius: 8)
    }

    @ViewBuilder
    private var sortButton: some View {
        Button {
            sortAction()
        } label: {
            Label {
                Text(Strings.sortBy.localized())
            } icon: {
                Image.chevronDown
            }
            .padding(8)
            .roundEdges(cornerRadius: 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Primary") {
    FilterView(searchText: .constant(""),
               filters: .constant([""]),
               results: 10) {
        print("Filter View pressed")
    }.padding()
}

#Preview("Primary - Light Mode"){
    FilterView(searchText: .constant(""),
               filters: .constant([""]),
               results: 10) {
        print("Filter View pressed")
    }.padding()
        .environment(\.colorScheme, .light)
}

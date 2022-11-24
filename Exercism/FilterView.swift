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
    @Binding var results: Int
    @Binding var searchText: String
    @Binding var filters: Set<String>

    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search language filters", text: $searchText)
                    .textFieldStyle(.plain)
            }.padding()
                .background(RoundedRectangle(cornerRadius: 14)
                    .fill(.black))

            RoundedRectButton(labelText: "Show Filters",
                              systemImage: "line.3.horizontal.decrease.circle") {
                showingSheet.toggle()
            }.popover(isPresented: $showingSheet) {
                FilterTableView(tags: Tag.loadTags(),
                                selectedTags: $filters,
                                isPresented: $showingSheet)
                .interactiveDismissDisabled(false)
            }

            Text("Showing all \(results) tracks")
                .padding()
                .frame(minHeight: 0, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 14)
                    .fill(.black))

            RoundedRectButton(labelText: "Sort by last touched",
                              systemImage: "chevron.down") {
                print("Sort by last touched")
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(results: .constant(10),
                   searchText: .constant(""),
                   filters: .constant([""]))
    }
}

struct RoundedRectButton: View {
    var labelText: String
    var systemImage: String
    var background = Color.black
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Label(labelText, systemImage: systemImage)
                .padding()
                .frame(minHeight: 0, maxHeight: .infinity)
                .background(background)
        }.buttonStyle(.plain)
            .cornerRadius(10)
            .padding(.horizontal, 10)
            .accessibilityLabel(labelText)
    }
}

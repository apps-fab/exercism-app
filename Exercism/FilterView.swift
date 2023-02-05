//
//  FilterView.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

import SwiftUI
import ExercismSwift

struct FilterView: View {
    @Binding var results: Int
    @Binding var searchText: String
    @Binding var filters: Set<String>
    @State private var showingSheet = false
    var sortAction: () -> Void

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Image(systemName: "magnifyingglass")
                TextField("Search language filters", text: $searchText)
                    .padding(.horizontal, 30)
                    .textFieldStyle(.plain)
            }.padding()
                .roundEdges()
             
            Button {
                showingSheet.toggle()
            } label: {
                Label("Show Filters", systemImage: "line.3.horizontal.decrease.circle")
            }.padding()
                .roundEdges()
                .buttonStyle(.plain)
                .popover(isPresented: $showingSheet) {
                    FilterTableView(tags: Tag.loadTags(),
                                    selectedTags: $filters,
                                    isPresented: $showingSheet)
                    .interactiveDismissDisabled(false)
                }

            Text("Showing all \(results) tracks")
                .padding()
                .roundEdges()

            Button {
                sortAction()
            } label: {
                Label("Sort by last touched", systemImage: "chevron.down")
            }.padding()
            .roundEdges()
                .buttonStyle(.plain)
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(results: .constant(10),
                   searchText: .constant(""),
                   filters: .constant([""])) {
            print("Filter View pressed")
        }
    }
}

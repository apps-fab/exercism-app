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
     var results: Int
    @Binding var searchText: String
    @Binding var filters: Set<String>
    @FocusState private var fieldFocused: Bool
    var sortAction: () -> Void
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Image(systemName: ExercismImages.magnifyingGlass.rawValue)
                TextField(Strings.searched.localized(),
                          text: $searchText)
                    .padding(.horizontal, 30)
                    .textFieldStyle(.plain)
            }.padding()
                .roundEdges(lineColor: fieldFocused ? .purple : .gray)
                .focused($fieldFocused)
             
            Button {
                showingSheet.toggle()
            } label: {
                Label(Strings.filterBy.localized(),
                      systemImage: ExercismImages.slider.rawValue)
            }.padding()
                .roundEdges(lineColor: showingSheet ? .purple : .gray)
                .buttonStyle(.plain)
                .popover(isPresented: $showingSheet) {
                    FilterTableView(tags: Tag.loadTags(),
                                    selectedTags: $filters,
                                    isPresented: $showingSheet)
                    .interactiveDismissDisabled(false)
                }

            Text(String(format: Strings.showingTracks.localized(), results))
                .padding()
                .roundEdges(backgroundColor: Color.primary.opacity(0.2))

            Button {
                sortAction()
            } label: {
                Label(Strings.sortBy.localized(),
                      systemImage: ExercismImages.chevron.rawValue)
            }.padding()
            .roundEdges()
                .buttonStyle(.plain)
        }.onAppear {
            fieldFocused = false
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(results: 10,
                   searchText: .constant(""),
                   filters: .constant([""])) {
            print("Filter View pressed")
        }
    }
}

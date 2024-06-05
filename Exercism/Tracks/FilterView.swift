//
//  FilterView.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

import SwiftUI
import ExercismSwift

struct FilterView: View {
    var results: Int
    @Binding var searchText: String
    @Binding var filters: Set<String>
    var sortAction: () -> Void

    @State private var showingSheet = false
    @FocusState private var fieldFocused: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image.magnifyingGlass
                    .imageScale(.large)
                
                TextField(Strings.searchTrackString.localized(),
                          text: $searchText)
                .textFieldStyle(.plain)
            }
            .padding(8)
            .roundEdges(
                lineColor: fieldFocused ? .purple : .gray,
                cornerRadius: 8
            )
            .focused($fieldFocused)
            
            Button {
                showingSheet.toggle()
            } label: {
                Label {
                    Text(Strings.filterBy.localized())
                } icon: {
                    Image.slider
                }
                .padding(8)
                .roundEdges(
                    lineColor: showingSheet ? .purple : .gray,
                    cornerRadius: 8
                )
                .contentShape(Rectangle())
            }
            
            .buttonStyle(.plain)
            .popover(isPresented: $showingSheet) {
                FilterTableView(tags: Tag.loadTags(),
                                selectedTags: $filters,
                                isPresented: $showingSheet)
                .interactiveDismissDisabled(false)
            }
            Text(String(format: Strings.showingTracks.localized(), results))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.9)
                .lineLimit(1)
                .padding(8)
                .roundEdges(
                    backgroundColor: Color.appPurple.opacity(0.2),
                    lineColor: .clear,
                    cornerRadius: 8
                )
            
            Button {
                sortAction()
            } label: {
                Label{
                    Text(Strings.sortBy.localized())
                } icon: {
                    Image.chevronDown
                }
                .padding(8)
                .roundEdges(
                    cornerRadius: 8
                )
                .contentShape(Rectangle()) 
            }
            .buttonStyle(.plain)
        }
        .onAppear {
            fieldFocused = false
        }
    }
}

#Preview {
    FilterView(results: 10,
               searchText: .constant(""),
               filters: .constant([""])
    ) {
        print("Filter View pressed")
    }
    .padding()
}

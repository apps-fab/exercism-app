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

    var body: some View {
            HStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("", text: .constant("Search language filters"))
                        .textFieldStyle(.plain)
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(.black))

                RoundedRectButton(labelText: "Show Filters",
                                  systemImage: "line.3.horizontal.decrease.circle") {
                    showingSheet.toggle()
                }.sheet(isPresented: $showingSheet) {
                    FilterTableView(tags: Tag.loadTags(), isPresented: $showingSheet).frame(minHeight: 500)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Text("Showing all 26 tracks")
                    .padding()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(RoundedRectangle(cornerRadius: 14)
                        .fill(.black))

                RoundedRectButton(labelText: "Sort by last touched",
                                  systemImage: "chevron.down") {
                    showingSheet.toggle()
                }.sheet(isPresented: $showingSheet) {
                    FilterTableView(tags: Tag.loadTags(), isPresented: $showingSheet)
                }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
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
    }
}

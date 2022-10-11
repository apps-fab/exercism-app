//
//  FilterView.swift
//  Exercism
//
//  Created by Angie Mugo on 11/10/2022.
//

import SwiftUI

struct FilterView: View {
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("", text: .constant("Search language filters"))
                    .textFieldStyle(.plain)
            }.padding()
                .background(RoundedRectangle(cornerRadius: 14))

            Button {
                showFilters()
            } label: {
                Label("Show Filters", systemImage: "line.3.horizontal.decrease.circle").frame(minHeight: 0, maxHeight: .infinity)
            }
            .padding(.horizontal, 10)
            Text("Showing all 26 tracks")
            Button {
                showFilters()
            } label: {
                Label("Sort by last touched", systemImage: "chevron.down").frame(minHeight: 0, maxHeight: .infinity)
            }.padding()
        }
    }

    func showFilters() {
        fatalError()
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}

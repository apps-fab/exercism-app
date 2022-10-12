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
                .background(RoundedRectangle(cornerRadius: 14)
                    .fill(.black))

            Button {
                showFilters()
            } label: {
                Label("Show Filters", systemImage: "line.3.horizontal.decrease.circle")
                    .padding()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(.black)
            }.buttonStyle(.plain)
                .cornerRadius(10)
                .padding(.horizontal, 10)

            Text("Showing all 26 tracks")
                .padding()
                .frame(minHeight: 0, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 14)
                .fill(.black))
            Button {
                showFilters()
            } label: {
                Label("Sort by last touched", systemImage: "chevron.down")
                    .padding()
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .background(.black)
            }.buttonStyle(.plain)
                .cornerRadius(10)
                .padding(.horizontal, 10)
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

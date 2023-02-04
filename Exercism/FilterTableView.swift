//
//  FilterTableView.swift
//  Exercism
//
//  Created by Angie Mugo on 12/10/2022.
//

import SwiftUI
import ExercismSwift

struct FilterTableView: View {
    @State var tags = [Tag]()
    @Binding var selectedTags: Set<String>
    @Binding var isPresented: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
                ForEach(tags, id: \.self) { tag in
                    VStack(alignment: .leading) {
                        Text(tag.type).bold().padding(.vertical, 5)
                        ForEach(tag.tags, id: \.self) { tags in
                            Button {
                                toggle(tags)
                            } label: {
                                Label(tags, systemImage: selectedTags.contains(tags) ? "checkmark.square" : "square")
                            }.buttonStyle(.plain).padding(2)
                        }
                    }
                }
            }
            HStack(spacing: 5) {
                Button("Apply") {
                    isPresented = false
                }.frame(height: 50)
                    .roundEdges(backgroundColor: .purple)
                Button("Close") {
                    selectedTags.removeAll()
                    isPresented = false
                }.frame(height: 50)
                    .roundEdges(backgroundColor: .purple)
            }.frame(alignment: .bottomLeading)
        }.padding()
    }

    func toggle(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

struct FilterTableView_Previews: PreviewProvider {
    static var previews: some View {
        FilterTableView(selectedTags: .constant(["Functional"]), isPresented: .constant(false))
    }
}

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
                        ForEach(tag.tags, id: \.self) { tag in
                            setupTag(tag)
                        }
                    }
                }
            }
            HStack(spacing: 5) {
                Button("Apply") {
                    isPresented = false
                }.frame(width: 100, height: 30)
                    .buttonStyle(.plain)
                    .roundEdges(backgroundColor: LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing), lineColor: .clear)
                Button("Close") {
                    selectedTags.removeAll()
                    isPresented = false
                }.frame(width: 100, height: 30)
                    .buttonStyle(.plain)
                    .roundEdges(backgroundColor: Color.gray)
            }.frame(alignment: .bottomLeading)
        }.padding()
    }

    func setupTag(_ tag: String) -> some View {
        let button = Button {
            toggleTags(tag)
        } label: {
            Label {
                Text(tag)
            } icon: {
                if selectedTags.contains(tag) {
                    Image(systemName: "checkmark.square.fill").renderingMode(.template).colorMultiply(.purple)
                } else {
                    Image(systemName: "square")
                }
            }
        }.buttonStyle(.plain)
            .padding(2)
        return button
    }

    func toggleTags(_ tag: String) {
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

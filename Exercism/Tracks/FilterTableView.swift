//
//  FilterTableView.swift
//  Exercism
//
//  Created by Angie Mugo on 12/10/2022.
//

import SwiftUI
import ExercismSwift

struct FilterTableView: View {
    @State private var tags = [Tag]()
    @State private var isLoading = true
    @Binding var selectedTags: Set<String>
    @Binding var isPresented: Bool
    let gradientColors = [Color.appAccent.opacity(0.4),
                          Color.appAccent.opacity(0.6),
                          Color.appAccent.opacity(0.8),
                          Color.appAccent]

    var body: some View {
        Group {
            if isLoading {
                EmptyView()
            } else {
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
                        Button(Strings.apply.localized()) {
                            isPresented = false
                        }.frame(width: 100, height: 30)
                            .buttonStyle(.plain)
                            .roundEdges(backgroundColor: LinearGradient(colors: gradientColors,
                                                                        startPoint: .leading,
                                                                        endPoint: .trailing),
                                        lineColor: .clear)
                        Button(Strings.close.localized()) {
                            selectedTags.removeAll()
                            isPresented = false
                        }.frame(width: 100, height: 30)
                            .buttonStyle(.plain)
                            .roundEdges(backgroundColor: Color.gray)
                    }.frame(alignment: .bottomLeading)
                }
            }
        }.padding()
            .frame(maxWidth: .infinity)
            .task {
                tags = Tag.loadTags()
                isLoading = false
            }
    }

    private func setupTag(_ tag: String) -> some View {
        Button {
            toggleTags(tag)
        } label: {
            Label {
                Text(tag)
                    .lineLimit(1)
                    .frame(minWidth: 80, alignment: .leading)
            } icon: {
                if selectedTags.contains(tag) {
                    Image.checkmarkSquareFill
                        .renderingMode(.template)
                        .colorMultiply(.appAccent)
                } else {
                    Image.square
                }
            }
        }.buttonStyle(.plain)
            .padding(2)
    }

    private func toggleTags(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
}

#Preview {
    FilterTableView(selectedTags: .constant(["Functional"]),
                    isPresented: .constant(false))
    .frame(maxWidth: .infinity)
}

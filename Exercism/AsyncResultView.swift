//
//  AsyncResultView.swift
//  Exercism
//
//  Created by Angie Mugo on 09/04/2023.
//

import SwiftUI

struct AsyncResultView<Source: LoadableObject, Content: View>: View {
    @ObservedObject var source: Source
    var content: (Source.Value) -> Content
    
    init(source: Source,
         @ViewBuilder content: @escaping (Source.Value) -> Content) {
        self.source = source
        self.content = content
    }
    
    var body: some View {
        Group {
            switch source.state {
            case .idle:
                EmptyView()
            case .loading:
                Spacer()
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
                Spacer()
            case .failure(let error):
                Spacer()
                Text(error.description)
                Spacer()
            case .success(let output):
                content(output)
            }
        }.task {
            await source.load()
        }
    }
}

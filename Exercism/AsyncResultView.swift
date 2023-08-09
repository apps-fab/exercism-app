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
                ProgressView()
            case .failure(let error):
                Text(error.localizedDescription)
            case .success(let output):
                content(output)
            }
        }.task {
            await source.load()
        }
    }
}
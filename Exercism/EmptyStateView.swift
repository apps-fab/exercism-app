//
//  EmptyStateView.swift
//  Exercism
//
//  Created by Angie Mugo on 27/06/2023.
//

import SwiftUI

struct EmptyStateView: View {
    let reloadAction: () -> Void

    var body: some View {
        Spacer()
        VStack {
            Image("exercismLogoSmall")
            Text("No results found")
                .bold()
                .foregroundColor(.secondary)
            Button {
                reloadAction()
            } label: {
                Label("Reset search and filters",
                      systemImage: "arrow.uturn.backward.circle")
                    .bold()
            }
        }
        Spacer()
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(reloadAction: { print("some")})
    }
}

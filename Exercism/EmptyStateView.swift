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
            Image.exercodeLogo
            Text(Strings.noResults.localized())
                .bold()
                .foregroundColor(.secondary)
            Button {
                reloadAction()
            } label: {
                Label {
                    Text(Strings.resetFilters.localized())
                } icon: {
                    Image.undo
                }.bold()
            }
        }
        Spacer()
    }
}

#Preview {
    EmptyStateView(reloadAction: { print("some")})
}

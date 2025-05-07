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
        VStack {
            Spacer()
            VStack(spacing: 16) {
                Image.exercodeLogo
                    .resizable()
                    .frame(width: 100, height: 50)

                Text(Strings.noResults.localized())
                    .bold()
                    .foregroundColor(.secondary)

                Button(action: reloadAction) {
                    Label {
                        Text(Strings.resetFilters.localized())
                    } icon: {
                        Image.undo
                    }
                    .bold()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(reloadAction: { print("some")})
}

//
//  ProfileTableView.swift
//  Exercism
//
//  Created by Angie Mugo on 05/02/2023.
//

import SwiftUI

enum ProfileItems: String, CaseIterable, Identifiable {
    var id: String { UUID().uuidString }

    case Profile = "Public profile"
    case Journey = "Your journey"
    case Settings
    case SignOut = "Sign out"
}

struct ProfileTableView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                VStack {
                    Text("Angie Mugo")
                    Text("@AngieMugo")
                }
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }.padding([.leading, .top])
            List(ProfileItems.allCases) { item in
                Text(item.rawValue)
            }
        }
    }
}

struct ProfileTableView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTableView()
    }
}

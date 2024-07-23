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
    @State private var selection: ProfileItems = .Profile
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image.profile
                    .resizable()
                    .frame(width: 32, height: 32)
                VStack {
                    Text("Angie Mugo")
                    Text("@AngieMugo")
                }
                Image.logout
            }.padding([.leading, .top])
            #if os(macOS)
            List(ProfileItems.allCases, selection: $selection) { item in
                Text(item.rawValue).foregroundColor(selection == item ? .purple : .primary)
            }
            #else
            List(ProfileItems.allCases) { item in 
                Text(item.rawValue)
            }
            #endif
        }
    }
}

struct ProfileTableView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTableView()
    }
}

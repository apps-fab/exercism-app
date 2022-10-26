//
//  ContentView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import ExercismSwift
import KeychainSwift

struct ContentView: View {
    var body: some View {
//        if let _ = ExercismKeychain.shared.get(for: "token") {
//            DashBoard()
//        } else {
            LoginView()
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

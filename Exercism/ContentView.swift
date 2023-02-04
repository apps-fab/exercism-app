//
//  ContentView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    var body: some View {
        Coordinator()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingData())
    }
}

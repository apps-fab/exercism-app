//
//  ContentView.swift
//  Exercism
//
//  Created by Kirk Agbenyegah on 04/07/2022.
//

import SwiftUI
import ExercismSwift

struct ContentView: View {
    // check if we are logged in, if not then go to dashboard screen 
    var body: some View {
        TracksView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

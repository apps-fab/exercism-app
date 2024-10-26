//
//  ExercismCommands.swift
//  Exercism
//
//  Created by Angie Mugo on 21/07/2023.
//

import SwiftUI

struct ExercismCommands: Commands {

    var body: some Commands {
        SidebarCommands()
        WindowCommands()
        ViewCommands()
        MainCommands()
    }
}

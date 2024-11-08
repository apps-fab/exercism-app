//
//  NoTestRunView.swift
//  Exercode
//
//  Created by Angie Mugo on 06/11/2024.
//

import SwiftUI

struct NoTestRun: View {
    var body: some View {
        VStack {
            Image.gear
            Text(Strings.runTestsTitle.localized())
            Text(Strings.runTestsDescription.localized())
                .multilineTextAlignment(.center)
        }.padding()
    }
}

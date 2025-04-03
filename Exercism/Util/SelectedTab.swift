//
//  SelectedTab.swift
//  Exercode
//
//  Created by Angie Mugo on 28/03/2025.
//

import Foundation

enum SelectedTab: Int, Tabbable {
    case instruction = 0
    case result
    case tests

    var icon: String {
        switch self {
        case .instruction:
            return "list.bullet"
        case .result:
            return "checkmark.icloud.fill"
        case .tests:
            return "checklist.unchecked"
        }
    }

    var title: String {
        switch self {
        case .instruction:
            return "Instruction"
        case .result:
            return "Result"
        case .tests:
            return "Tests"
        }
    }
}

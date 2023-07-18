//
//  Images.swift
//  Exercism
//
//  Created by Angie Mugo on 18/07/2023.
//

import Foundation
import SwiftUI

enum ExercismImages: String {
    case conceptLogo = "concept"
    case exerciseLogo = "Exercise"
    case exercismLogo = "exercismLogo"
    case exercismLogoSmall = "exercismLogoSmall"
    case mainLogo = "mainLogo"
    case starsLogo = "stars"
    case trackImages = "trackImages"

    case magnifyingGlass = "magnifyingglass"
    case slider = "slider.horizontal.3"
    case chevron = "chevron.down"
    case checkmarkFill = "checkmark.square.fill"
    case square = "square"

    func image() -> Image {
        return Image(self.rawValue)
    }
}

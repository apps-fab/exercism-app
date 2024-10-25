//
//  Date+Exercism.swift
//  Exercism
//
//  Created by Angie Mugo on 27/09/2022.
//

import Foundation
import SwiftUI

extension Date {
    func offsetFrom() -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: self, to: Date())

        let seconds = "\(difference.second ?? 0) seconds"
        let minutes = "\(difference.minute ?? 0) minutes"
        let hours = "\(difference.hour ?? 0) hours"
        let days = "\(difference.day ?? 0) days"
        let months = "\(difference.month ?? 0) months"
        let years = "\(difference.year ?? 0) years"

        if let year = difference.year, year         > 0 { return years }
        if let month = difference.month, month          > 0 { return months }
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
}

extension String {
    func getLink(_ color: Color, linkText: String, linkURL: String) -> AttributedString {
        var attributedString = AttributedString(self)

        if let linkRange = attributedString.range(of: linkText) {
            attributedString[linkRange].link = URL(string: linkURL)
            attributedString[linkRange].foregroundColor = color
        }
        return attributedString
    }
}

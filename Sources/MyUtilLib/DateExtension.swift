//
//  DateExtension.swift
//  MyUtilLib
//
//  Created by Deepak Malkan on 9/25/26.
//

import Foundation

public extension Date {

    /// Returns a condensed string representation of the date.
    ///
    /// The precision of the representation decreases as the date becomes older:
    /// - Dates within the past month are represented as `yyyy-MM-dd`.
    /// - Dates within the past year are represented as `yyyy-MM`.
    /// - Older dates are represented as `yyyy`.
    ///
    /// The Gregorian calendar and UTC time zone are used for determining the
    /// date representation.
    ///
    /// - Returns: A string containing the date with an age-appropriate level
    ///   of precision.
    func condensedString () -> String {
        let now = Date ()
        let calendar = Calendar (identifier: .gregorian)

        let format: String

        if let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: now),
           self >= oneMonthAgo {
            format = "yyyy-MM-dd"
        } else if let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now),
                  self >= oneYearAgo {
            format = "yyyy-MM"
        } else {
            format = "yyyy"
        }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}

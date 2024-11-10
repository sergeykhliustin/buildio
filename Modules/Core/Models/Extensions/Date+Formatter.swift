//
//  Date+Formatter.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation

package extension Date {
    var full: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    var relativeToNow: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

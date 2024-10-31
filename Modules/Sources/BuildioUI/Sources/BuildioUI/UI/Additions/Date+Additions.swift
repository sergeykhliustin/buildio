//
//  Date+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 26.10.2021.
//

import Foundation

extension Date {
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

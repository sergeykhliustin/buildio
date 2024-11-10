//
//  TimeInterval+Formatter.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import Foundation

package extension TimeInterval {
    private static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.calendar?.locale = Locale(identifier: "en")
        return formatter
    }()

    func stringFromTimeInterval() -> String {
        return Double.formatter.string(from: self) ?? ""
    }
}

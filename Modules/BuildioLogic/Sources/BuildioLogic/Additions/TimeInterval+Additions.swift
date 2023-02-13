//
//  TimeInterval+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation

extension TimeInterval {
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

//
//  TimeInterval+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import Foundation

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.calendar?.locale = Locale(identifier: "en")
        return formatter.string(from: self) ?? ""
    }
}

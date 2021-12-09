//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI

extension ColorScheme {
    var theme: Theme {
        switch self {
        case .light:
            return lightTheme
        case .dark:
            return darkTheme
        @unknown default:
            return lightTheme
        }
    }
}

private let lightTheme = LightTheme()
private let darkTheme = DarkTheme()

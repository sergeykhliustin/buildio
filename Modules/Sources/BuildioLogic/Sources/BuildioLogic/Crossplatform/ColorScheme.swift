//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 03.02.2022.
//

import SwiftUI

extension ColorScheme {
    static var current: ColorScheme {
        #if os(macOS)
        return .light
        #else
        return ColorScheme(UIScreen.main.traitCollection.userInterfaceStyle) ?? .light
        #endif
    }
    
}

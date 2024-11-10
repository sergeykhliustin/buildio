//
//  Color+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 12.10.2021.
//

import SwiftUI

enum ColorHexError: Error {
    case decodeError
    case encodeError
}

package extension Color {
    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0)
    }
    
    init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    init(hex: String) throws {
        let uiColor = try PlatformColor(hex: hex)
        self.init(uiColor)
    }
    
    func hex() throws -> String {
        return platformColor.hex
    }

    private var platformColor: PlatformColor {
        return PlatformColor(self)
    }
}

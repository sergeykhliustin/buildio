//
//  Color+Rainbow.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//
#if canImport(Rainbow)
import Foundation
import SwiftUI
import Rainbow

extension SwiftUI.Color {
    static func color(for backgroundColorType: BackgroundColorType) -> SwiftUI.Color? {
        return Color.color(for: backgroundColorType.toColor)
    }
    
    static func color(for colorType: ColorType) -> SwiftUI.Color? {
        switch colorType {
        case .named(let color):
            return Color.color(for: color)
        case .bit24(let rGB):
            return Color(red: Int(rGB.0), green: Int(rGB.1), blue: Int(rGB.2))
        case .bit8(let uInt8):
            return Color(red: Double((uInt8 >> 5) * 32) / 255.0, green: Double(((uInt8 & 28) >> 2)) * 32 / 255.0, blue: Double((uInt8 & 3) * 64) / 255.0)
        }
    }
    
    static func color(for namedColor: NamedColor) -> SwiftUI.Color {
        let namedColorMap: [NamedColor: SwiftUI.Color] = [
            .black: .black,
            .red: .red,
            .green: .init(hex: 0x2ecc71),
            .yellow: .init(hex: 0x999900),
            .blue: .init(hex: 0x3498db),
            .magenta: .init(hex: 0xb200b2),
            .cyan: .init(hex: 0x00a6b2),
            .white: .white,
            .`default`: .init(hex: 0xb200b2), // the same like magenta
            .lightBlack: .gray,
            .lightRed: .init(hex: 0xFF7F7F),
            .lightGreen: .init(hex: 0xAED9B2),
            .lightYellow: .init(hex: 0xF7F1AF),
            .lightBlue: .init(hex: 0xB3CCF5),
            .lightMagenta: .init(hex: 0xFF77FF),
            .lightCyan: .init(hex: 0xE0FFFF),
            .lightWhite: .white
        ]
        
        return namedColorMap[namedColor]!
    }
}

#endif

//
//  Color+Rainbow.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//
#if canImport(Rainbow)
import Foundation
import UIKit
import Rainbow

extension UIColor {
    static func uiColor(for backgroundColorType: BackgroundColorType) -> UIColor? {
        return UIColor.uiColor(for: backgroundColorType.toColor)
    }
    
    static func uiColor(for colorType: ColorType) -> UIColor? {
        switch colorType {
        case .named(let color):
            return UIColor.uiColor(for: color)
        case .bit24(let rGB):
            return UIColor(red: Double(rGB.0) / 255.0, green: Double(rGB.1) / 255.0, blue: Double(rGB.2) / 255.0, alpha: 1.0)
        case .bit8(let uInt8):
            break
        }
        return nil
    }
    
    static func uiColor(for namedColor: NamedColor) -> UIColor {
        let namedColorMap: [NamedColor: UIColor] = [
            .black: .black,
            .red: .red,
            .green: .green,
            .yellow: .yellow,
            .blue: .blue,
            .magenta: .init(hex: 0xFF00FF),
            .cyan: .init(hex: 0x00FFFF),
            .white: .white,
            .`default`: .white, // TODO: check default color
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

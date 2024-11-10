//
//  File.swift
//  Modules
//
//  Created by Sergii Khliustin on 06.11.2024.
//

import Foundation
import Rainbow
import SwiftUI
import Assets
import Components

extension Rainbow {
    static func chunkToAttributed(_ chunk: String) -> NSAttributedString {
        let entry = Rainbow.extractEntry(for: chunk)
        return entry.segments.reduce(NSMutableAttributedString()) { partialResult, segment in
            partialResult.append(segment.attributedString)
            return partialResult
        }
    }
}

private extension Rainbow.Segment {
    var attributedString: NSAttributedString {
        let fontSize = 12.0
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[.font] = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        if let background = self.backgroundColor, let color = Color.color(for: background) {
            attributes[.backgroundColor] = UIColor(color)
        }
        if let foreground = self.color, let color = Color.color(for: foreground) {
            attributes[.foregroundColor] = UIColor(color)
        } else {
            attributes[.foregroundColor] = UIColor(Color.b_LogsDefault)
        }
        for style in styles ?? [] {
            switch style {
            case .bold:
                attributes[.font] = UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold)
            case .italic:
                attributes[.font] = UIFont.italicSystemFont(ofSize: fontSize)
            case .underline:
                attributes[.underlineStyle] = NSUnderlineStyle.single
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single
            default:
                break
            }
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
}

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

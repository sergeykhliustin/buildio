//
//  RainbowLogs.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import Foundation
import Rainbow
import SwiftUI

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

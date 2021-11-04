//
//  NSFont+Additions.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import AppKit
typealias UIFont = NSFont

extension NSFont {
    class func italicSystemFont(ofSize fontSize: CGFloat) -> NSFont {
        return NSFontManager.shared.convert(self.systemFont(ofSize: fontSize), toHaveTrait: .italicFontMask)
    }
}

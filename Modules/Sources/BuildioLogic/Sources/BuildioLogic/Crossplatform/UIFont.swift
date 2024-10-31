//
//  UIFont.swift
//  
//
//  Created by Sergey Khliustin on 03.02.2022.
//

#if os(macOS)
import AppKit
typealias UIFont = NSFont
extension NSFont {
    static func italicSystemFont(ofSize: CGFloat) -> NSFont {
        let font = NSFont.systemFont(ofSize: ofSize)
        return NSFontManager.shared.convert(font, toHaveTrait: .italicFontMask)
    }
}
#endif

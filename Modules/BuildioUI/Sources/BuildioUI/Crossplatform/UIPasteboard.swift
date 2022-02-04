//
//  UIPasteboard.swift
//  
//
//  Created by Sergey Khliustin on 04.02.2022.
//

#if os(macOS)
import AppKit
typealias UIPasteboard = NSPasteboard

extension NSPasteboard {
    var string: String? {
        self.string(forType: .string)
    }
}
#endif

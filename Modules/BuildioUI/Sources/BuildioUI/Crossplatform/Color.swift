//
//  Color.swift
//  
//
//  Created by Sergey Khliustin on 04.02.2022.
//

#if os(macOS)
import SwiftUI

extension Color {
    init(_ nsColor: NSColor) {
        self.init(nsColor: NSColor)
    }
}
#endif

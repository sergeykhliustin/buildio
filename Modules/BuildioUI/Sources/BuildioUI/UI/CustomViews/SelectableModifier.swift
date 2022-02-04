//
//  SelectableModifier.swift
//  
//
//  Created by Sergey Khliustin on 02.02.2022.
//

import Foundation
import SwiftUI

struct SelectableModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 15.0, macOS 12.0, *) {
            content.textSelection(.enabled)
        } else {
            content
        }
    }
}

extension View {
    func selectable() -> some View {
        return self.modifier(SelectableModifier())
    }
}

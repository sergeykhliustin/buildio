//
//  RoundedBorderShadowModifier.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import SwiftUI

package struct RoundedBorderShadowModifier: ViewModifier {
    @Environment(\.theme) private var theme
    private let focused: Bool
    private var borderColor: Color?
    private let horizontalPadding: CGFloat
    
    package init(focused: Bool = false, horizontalPadding: CGFloat = 16) {
        self.focused = focused
        self.horizontalPadding = horizontalPadding
    }
    
    package func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(focused ? theme.accentColor.color : theme.borderColor.color, lineWidth: 1)
                )
                .listShadow(theme)
            content
                .padding(.horizontal, horizontalPadding)
                .contentShape(Rectangle())
        }
    }
}

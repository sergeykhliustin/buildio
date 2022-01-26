//
//  RoundedBorderShadowModifier.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import Foundation
import SwiftUI

struct RoundedBorderShadowModifier: ViewModifier {
    @Environment(\.theme) private var theme
    private let focused: Bool
    private var borderColor: Color?
    private let horizontalPadding: CGFloat
    
    init(focused: Bool = false, horizontalPadding: CGFloat = 16) {
        self.focused = focused
        self.horizontalPadding = horizontalPadding
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(focused ? theme.accentColor : theme.borderColor, lineWidth: 1)
                )
                .listShadow(theme)
            content
                .padding(.horizontal, horizontalPadding)
                .contentShape(Rectangle())
        }
    }
}

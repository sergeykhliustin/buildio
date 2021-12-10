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
    var borderColor: Color?
    let horizontalPadding: CGFloat
    
    init(borderColor: Color? = nil, horizontalPadding: CGFloat = 16) {
        self.borderColor = borderColor
        self.horizontalPadding = horizontalPadding
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
//                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor ?? theme.borderColor, lineWidth: 1)
                )
                .listShadow(theme)
            content
                .padding(.horizontal, horizontalPadding)
                .contentShape(Rectangle())
        }
    }
}

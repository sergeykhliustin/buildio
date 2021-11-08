//
//  RoundedBorderShadowModifier.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 08.11.2021.
//

import Foundation
import SwiftUI

struct RoundedBorderShadowModifier: ViewModifier {
    let borderColor: Color
    let horizontalPadding: CGFloat
    
    init(borderColor: Color = Color.b_BorderLight, horizontalPadding: CGFloat = 16) {
        self.borderColor = borderColor
        self.horizontalPadding = horizontalPadding
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 1)
                )
                .shadow(color: .b_ShadowLight, radius: 3, y: 2)
            content
                .padding(.horizontal, horizontalPadding)
        }
    }
}

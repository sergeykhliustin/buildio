//
//  BorderButtonStyle.swift
//  
//
//  Created by Sergey Khliustin on 03.12.2021.
//

import Foundation
import SwiftUI

struct BorderButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    var padding: CGFloat = 4
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration
                .label
                .padding(padding)
        }
        .background(RoundedRectangle(cornerRadius: 0).stroke(configuration.isPressed ? theme.accentColor : theme.borderColor, lineWidth: 1))
        .contentShape(Rectangle())
    }
}

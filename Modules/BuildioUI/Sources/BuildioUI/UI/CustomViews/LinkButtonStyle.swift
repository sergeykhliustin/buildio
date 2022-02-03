//
//  LinkStyleButton.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import Foundation
import SwiftUI

struct LinkButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration
                .label
                .foregroundColor(theme.linkColor.opacity(configuration.isPressed ? 0.5 : 1.0))
        }
        .buttonStyle(.plain)
    }
}

//
//  LinkButtonStyle.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import Foundation
import SwiftUI
import Assets

struct LinkButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration
                .label
                .foregroundColor(theme.linkColor.color.opacity(configuration.isPressed ? 0.5 : 1.0))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Text("Link")
        .linkButton(action: {})
}

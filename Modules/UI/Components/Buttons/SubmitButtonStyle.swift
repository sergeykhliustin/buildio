//
//  SubmitButton.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import Foundation
import SwiftUI
import Assets

struct SubmitButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    var edgeInsets = EdgeInsets(top: 16, leading: 30, bottom: 16, trailing: 30)

    func makeBody(configuration: Configuration) -> some View {
        var colors: [Color] = [theme.submitButtonColor1.color, theme.submitButtonColor2.color]
        if configuration.isPressed {
            colors.removeFirst()
        }
        if !isEnabled {
            colors = [theme.disabledColor.color]
        }

        return configuration.label
            .padding(edgeInsets)
            .foregroundColor(.white)
            .font(.body.bold())
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .rounded(radius: 30)
    }
}

#Preview {
    Text("Submit")
        .buttonStyle(SubmitButtonStyle())
}

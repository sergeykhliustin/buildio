//
//  AbortButton.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import SwiftUI

package struct AbortButton: View {
    private let action: () -> Void
    
    package init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    package var body: some View {
        Button(action: action) {
            HStack {
                Text("Abort")
            }
        }
        .buttonStyle(AbortButtonStyle())
    }
}

struct AbortButtonStyle: ButtonStyle {
    var edgeInsets = EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 15)

    func makeBody(configuration: Configuration) -> some View {
        SButton(configuration: configuration, edgeInsets: edgeInsets)
    }

    struct SButton: View {
        @Environment(\.theme) private var theme
        let configuration: ButtonStyle.Configuration
        let edgeInsets: EdgeInsets
        @Environment(\.isEnabled) private var isEnabled: Bool

        var body: some View {
            var colors: [Color] = [theme.abortButtonColor1.color, theme.abortButtonColor2.color]

            if configuration.isPressed {
                colors.removeFirst()
            }
            if !isEnabled {
                colors = [theme.disabledColor.color]
            }

            return configuration.label
                .padding(edgeInsets)
                .foregroundColor(.white)
                .font(Font.body.bold())
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .top,
                        endPoint: .bottom
                    ).cornerRadius(20)
                )
        }
    }
}

#Preview {
    AbortButton {

    }
}

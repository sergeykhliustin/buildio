//
//  CustomListWrapperButtonStyle.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import SwiftUI

package struct ListItem<Content>: View where Content: View {
    @Environment(\.theme) private var theme
    let cornerRadius: Double
    let action: (() -> Void)?
    let content: () -> Content

    package init(cornerRadius: Double = 8, action: (() -> Void)? = nil, content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content
    }

    package var body: some View {
        if let action = action {
            Button(action: action, label: { content() })
                .buttonStyle(ListItemButtonStyle(cornerRadius: cornerRadius))
        } else {
            content()
                .modifier(ListItemModifier(cornerRadius: cornerRadius))
        }
    }
}

private struct ListItemButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    let cornerRadius: CGFloat
    @State private var hover: Bool = false

    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = configuration.isPressed || hover
        configuration
            .label
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .cornerRadius(cornerRadius)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(theme.background.color)
                        .listShadow(theme)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(highlighted ? theme.accentColor.color : .clear, lineWidth: 2)
                }
            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

private struct ListItemModifier: ViewModifier {
    @Environment(\.theme) private var theme
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .cornerRadius(cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.background.color)
                    .listShadow(theme)
            )
    }
}

#Preview {
    VStack {
        ListItem {
            Text("Hello, World!")
        }
        ListItem(
            action: {},
            content: {
                Text("Hello, World!")
            }
        )
    }
}

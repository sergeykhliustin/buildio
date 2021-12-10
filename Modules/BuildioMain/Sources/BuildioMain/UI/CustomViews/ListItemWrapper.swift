//
//  LIstItemWrapper.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI

private struct CustomListWrapperButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    let cornerRadius: CGFloat
    let handleHover: Bool
    @State private var hover: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = handleHover && (configuration.isPressed || hover)
        configuration
            .label
            .contentShape(Rectangle())
            .cornerRadius(cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.background)
                    .listShadow(theme)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius).stroke(highlighted ? theme.accentColor : .clear, lineWidth: 2)
                    
            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct ListItemWrapper<Content>: View where Content: View {
    let cornerRadius: CGFloat
    let action: (() -> Void)?
    @ViewBuilder var content: () -> Content
    
    init(cornerRadius: CGFloat = 8, action: (() -> Void)? = nil, content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: { action?() }, label: content)
            .buttonStyle(CustomListWrapperButtonStyle(cornerRadius: cornerRadius, handleHover: action != nil))
            .padding(.horizontal, 16)
    }
}

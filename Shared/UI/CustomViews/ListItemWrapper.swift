//
//  LIstItemWrapper.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI

private struct CustomListWrapperButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat
    @State private var hover: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = configuration.isPressed || hover
        configuration
            .label
            .contentShape(Rectangle())
            .cornerRadius(cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .shadow(color: .b_ShadowLight, radius: 10, y: 0)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius).stroke(highlighted ? Color.b_Primary : .clear, lineWidth: 2)
                    
            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct ListItemWrapper<Content>: View where Content: View {
    let cornerRadius: CGFloat
    let action: (() -> Void)
    @ViewBuilder var content: () -> Content
    
    init(cornerRadius: CGFloat = 8, action: @escaping () -> Void, content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: action, label: content)
            .buttonStyle(CustomListWrapperButtonStyle(cornerRadius: cornerRadius))
            .padding(.horizontal, 16)
    }
}

//
//  CustomTabBar.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

private struct CustomTabBarButtonStyle: ButtonStyle {
    let selected: Bool
    @State private var hover: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = selected || configuration.isPressed || hover
        configuration
            .label
            .contentShape(Rectangle())
            .foregroundColor(highlighted ? Color.b_Primary : Color.b_PrimaryLight)
//            .background(
//                RoundedRectangle(cornerRadius: 4).stroke(highlighted ? Color.b_Primary : .clear, lineWidth: 1)
//            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct CustomTabBar<Content>: View where Content: View {
    enum Style {
        case horizontal
        case vertical
    }
    @Binding var selected: Int
    @ViewBuilder var content: (Int) -> Content
    private let count: Int
    private let spacing: CGFloat
    private let style: Style
    private let onSecondTap: (() -> Void)?

    init(style: Style = .horizontal, spacing: CGFloat = 4, count: Int, selected: Binding<Int>, onSecondTap: (() -> Void)? = nil, @ViewBuilder content: @escaping (Int) -> Content) {
        self.spacing = spacing
        self.count = count
        self._selected = selected
        self.content = content
        self.style = style
        self.onSecondTap = onSecondTap
    }
    
    var body: some View {
        stack(style: style) {
            Group {
                Spacer()
                ForEach(0..<count) { index in
                    
                    Button(action: {
                        if selected == index {
                            logger.debug("UI on second tap")
                            onSecondTap?()
                        } else {
                            selected = index
                        }
                    }, label: {
                        VStack(alignment: .center, spacing: 6) {
                            content(index)
                        }
                        .frame(maxWidth: .infinity)
                    })
                        .buttonStyle(CustomTabBarButtonStyle(selected: selected == index))
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func stack<Content: View>(style: CustomTabBar.Style, content: () -> Content) -> some View {
        switch style {
        case .horizontal:
            horizontal(content)
        case .vertical:
            vertical(content)
        }
    }
    
    @ViewBuilder
    private func horizontal<Content: View>(_ content: () -> Content) -> some View {
        HStack(spacing: 0) {
            content()
        }
        .padding(.top, 4)
        .frame(maxHeight: 48)
        .background(Color.white.shadow(color: .b_ShadowLight, radius: 3, y: -5))
    }
    
    @ViewBuilder
    private func vertical<Content: View>(_ content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(.trailing, 4)
        .frame(maxWidth: 64)
        .border(Color.b_ShadowLight, width: 1)
//        .background(Color.white.shadow(color: .b_ShadowLight, radius: 3, x: 5))
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(style: .vertical, count: 1, selected: .constant(0)) { _ in
            Image(systemName: "hammer.fill")
                .frame(maxWidth: .infinity)
            Text("Builds")
                .frame(maxWidth: .infinity)
        }
        
        CustomTabBar(style: .horizontal, count: 1, selected: .constant(0)) { _ in
            Image(systemName: "hammer.fill")
                .frame(maxWidth: .infinity)
            Text("Builds")
                .frame(maxWidth: .infinity)
        }
    }
}

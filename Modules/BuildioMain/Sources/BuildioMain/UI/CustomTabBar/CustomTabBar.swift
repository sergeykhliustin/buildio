//
//  CustomTabBar.swift
//  Buildio
//
//  Created by Sergey Khliustin on 05.11.2021.
//

import SwiftUI

private struct CustomTabBarButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    let selected: Bool
    @State private var hover: Bool = false
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = selected || configuration.isPressed || hover
        configuration
            .label
            .contentShape(Rectangle())
            .foregroundColor(highlighted ? theme.accentColor : theme.accentColorLight)
//            .background(
//                RoundedRectangle(cornerRadius: 4).stroke(highlighted ? Color.b_Primary : .clear, lineWidth: 1)
//            )
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct CustomTabBar: View {
    struct Constants {
        static let horizontalWidth: CGFloat = 64
        static let verticalHeight: CGFloat = 48
    }
    enum Style {
        case horizontal
        case vertical
    }
    @Binding var selected: Int
    private let spacing: CGFloat
    private let style: Style
    private let onSecondTap: (() -> Void)?
    @EnvironmentObject private var navigators: Navigators
    @Environment(\.theme) private var theme
    @Environment(\.previewMode) private var previewMode

    init(style: Style = .horizontal, spacing: CGFloat = 4, selected: Binding<Int>, onSecondTap: (() -> Void)? = nil) {
        self.spacing = spacing
        self._selected = selected
        self.style = style
        self.onSecondTap = onSecondTap
    }
    
    var body: some View {
        let configuration = previewMode ? RootScreenItemType.preview : RootScreenItemType.default
        stack(style: style) {
            Group {
                Spacer()
                ForEach(0..<configuration.count) { index in
                    let item = configuration[index]
                    Button(action: {
                        if selected == index {
                            logger.debug("UI on second tap")
                            onSecondTap?()
                            navigators.popToRoot(type: item)
                        } else {
                            selected = index
                        }
                    }, label: {
                        VStack(alignment: .center, spacing: 6) {
                            Image(systemName: item.icon + (selected == index ? ".fill" : ""))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(item.name)
                                .font(.footnote)
                        }
                        .frame(maxWidth: .infinity)
                    })
                        .buttonStyle(CustomTabBarButtonStyle(selected: selected == index))
                    Spacer()
                }
            }
        }
        .overlay(
            navigators.isPresentingModal ? Color.black.opacity(0.15) : nil
        )
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
        .frame(maxHeight: Constants.verticalHeight)
        .tabBarBackgroundShadow(theme)
    }
    
    @ViewBuilder
    private func vertical<Content: View>(_ content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .padding(.trailing, 4)
        .frame(maxWidth: Constants.horizontalWidth)
        .background(
            HStack(spacing: 0) {
                Spacer()
                Rectangle().fill(theme.borderColor).frame(width: 1, alignment: .trailing)
            }
        )
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(style: .vertical, selected: .constant(0))
        CustomTabBar(style: .horizontal, selected: .constant(0))
    }
}

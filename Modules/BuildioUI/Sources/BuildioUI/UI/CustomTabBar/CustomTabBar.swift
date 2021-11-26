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

struct CustomTabBar: View {
    struct Configuration {
        struct Item {
            let title: String
            let icon: String
        }
        let items: [Item]
        
        static let `default` = Configuration(items: RootScreenItemType.default.map({ Item(title: $0.name, icon: $0.icon) }))
    }
    enum Style {
        case horizontal
        case vertical
    }
    @Binding var selected: Int
    private let configuration: Configuration
    private let spacing: CGFloat
    private let style: Style
    private let onSecondTap: (() -> Void)?

    init(style: Style = .horizontal, spacing: CGFloat = 4, selected: Binding<Int>, configuration: Configuration = .default, onSecondTap: (() -> Void)? = nil) {
        self.spacing = spacing
        self._selected = selected
        self.style = style
        self.configuration = configuration
        self.onSecondTap = onSecondTap
    }
    
    var body: some View {
        stack(style: style) {
            Group {
                Spacer()
                ForEach(0..<configuration.items.count) { index in
                    let item = configuration.items[index]
                    Button(action: {
                        if selected == index {
                            logger.debug("UI on second tap")
                            onSecondTap?()
                        } else {
                            selected = index
                        }
                    }, label: {
                        VStack(alignment: .center, spacing: 6) {
                            Image(systemName: item.icon + (selected == index ? ".fill" : ""))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text(item.title)
                                .font(.footnote)
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
        let configuration = CustomTabBar.Configuration(items: [
            CustomTabBar.Configuration.Item(title: "Builds", icon: "hammer"),
            CustomTabBar.Configuration.Item(title: "Builds", icon: "hammer")
        ])
        CustomTabBar(style: .vertical, selected: .constant(0), configuration: configuration)
        CustomTabBar(style: .horizontal, selected: .constant(0), configuration: configuration)
    }
}

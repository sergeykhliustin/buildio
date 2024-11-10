//
//  BuildioTabBar.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import SwiftUI
import Assets

package enum BuildioTabItem: CaseIterable, Identifiable {
    case builds
    case apps
    case accounts
    case activities
    case settings

    package var id: String {
        return name
    }

    var name: String {
        switch self {
        case .builds:
            return "Builds"
        case .apps:
            return "Apps"
        case .accounts:
            return "Accounts"
        case .activities:
            return "Activities"
        case .settings:
            return "Settings"
        }
    }

    var icon: Images {
        switch self {
        case .builds:
            return .hammer
        case .apps:
            return .tray_2
        case .accounts:
            return .key
        case .activities:
            return .bell
        case .settings:
            return .gearshape
        }
    }

    var iconFill: Images {
        switch self {
        case .builds:
            return .hammer_fill
        case .apps:
            return .tray_2_fill
        case .accounts:
            return .key_fill
        case .activities:
            return .bell_fill
        case .settings:
            return .gearshape_fill
        }
    }

    package static let `default`: [BuildioTabItem] = [
        .builds,
        .apps,
        .activities,
        .accounts,
        .settings,
    ]

    package static let preview: [BuildioTabItem] = [
        .builds,
        .apps,
    ]
}

package struct BuildioTabBar: View {
    struct Constants {
        static let horizontalWidth: CGFloat = 68
        static let verticalHeight: CGFloat = 48
    }
    package enum Style {
        case horizontal
        case vertical
    }
    private let tabs: [BuildioTabItem]
    @Binding var selected: BuildioTabItem
    private let spacing: CGFloat
    private let style: Style
    private let onSecondTap: ((BuildioTabItem) -> Void)?
    @Environment(\.theme) private var theme

    package init(
        tabs: [BuildioTabItem],
        style: Style = .horizontal,
        spacing: CGFloat = 4,
        selected: Binding<BuildioTabItem>,
        onSecondTap: ((BuildioTabItem) -> Void)? = nil
    ) {
        self.tabs = tabs
        self.spacing = spacing
        self._selected = selected
        self.style = style
        self.onSecondTap = onSecondTap
    }

    package var body: some View {
        stack(style: style) {
            Group {
                Spacer()
                ForEach(tabs) { item in
                    VStack(alignment: .center, spacing: 6) {
                        Image(selected == item ? item.iconFill : item.icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text(item.name)
                            .font(.footnote)
                    }
                    .contentShape(Rectangle())
                    .button {
                        if selected == item {
                            onSecondTap?(item)
                        } else {
                            withAnimation {
                                selected = item
                            }
                        }
                    }
                    .buttonStyle(BuildioTabBarButtonStyle(selected: selected == item))
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    private func stack<Content: View>(style: BuildioTabBar.Style, content: () -> Content) -> some View {
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
                Rectangle().fill(theme.separatorColor.color).frame(width: 1, alignment: .trailing)
            }
        )
    }
}

private struct BuildioTabBarButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    let selected: Bool
    @State private var hover: Bool = false

    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        let highlighted = selected || configuration.isPressed || hover
        configuration
            .label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .contentShape(Rectangle())
            .foregroundColor(highlighted ? theme.accentColor.color : theme.accentColorLight.color)
            .onHover { hover in
                self.hover = hover
            }
    }
}

#Preview {
    BuildioTabBar(tabs: [.builds, .apps, .accounts, .activities, .settings], style: .vertical, selected: .constant(.builds))
    BuildioTabBar(tabs: [.builds, .apps, .accounts, .activities, .settings], style: .horizontal, selected: .constant(.builds))
}

//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI

protocol Theme {
    typealias Shadow = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    
    var background: Color { get }
    var textColor: Color { get }
    var textColorLight: Color { get }
    var accentColor: Color { get }
    var accentColorLight: Color { get }
    var linkColor: Color { get }
    var submitButtonColors: [Color] { get }
    var disabledColor: Color { get }
    var borderColor: Color { get }
    var logControlColor: Color { get }
    var logsBackgroundColor: Color { get }
    var shadowColor: Color { get }
    var listShadow: Shadow { get }
    var tabBarBackgroundShadow: Shadow { get }
}

enum ThemeHelper {
    static var current: Theme {
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        switch style {
        case .unspecified:
            return LightTheme()
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        @unknown default:
            return LightTheme()
        }
    }
    
    static func theme(for colorScheme: ColorScheme) -> Theme {
        if colorScheme == .dark {
            return DarkTheme()
        } else {
            return LightTheme()
        }
    }
}

final class ThemeObject: ObservableObject {
    @Published var theme: Theme
    init(_ colorScheme: ColorScheme) {
//        UIScreen.main.traitCollection.userInterfaceStyle
        switch colorScheme {
        case .light:
            theme = LightTheme()
        case .dark:
            theme = DarkTheme()
        @unknown default:
            theme = LightTheme()
        }
    }
    
    func update(_ colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            theme = LightTheme()
        case .dark:
            theme = DarkTheme()
        @unknown default:
            theme = LightTheme()
        }
    }
}

struct LightTheme: Theme {
    let background: Color = .white
    let textColor = Color(hex: 0x351d48)
    let textColorLight = Color(hex: 0x351d48).opacity(0.6)
    let accentColor = Color(hex: 0x4a2e5c)
    let accentColorLight = Color(hex: 0x4a2e5c).opacity(0.6)
    let linkColor = Color(hex: 0x6c0eb2)
    let submitButtonColors = [Color(hex: 0x6c0eb2), Color(hex: 0x450674)]
    let disabledColor = Color(hex: 0xdedede)
    let borderColor = Color(hex: 0xdedede)
    let logControlColor = Color(hex: 0xdedede)
    let logsBackgroundColor = Color(hex: 0x2c3e50)
    let shadowColor = Color(hex: 0x0).opacity(0.1)

    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }
    
    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
}

struct DarkTheme: Theme {
    let background = Color(hex: 0x2c3e50)
    let textColor = Color.white
    let textColorLight = Color.white.opacity(0.6)
    let accentColor = Color.green
    let accentColorLight = Color.green.opacity(0.6)
    let linkColor = Color(hex: 0x6c0eb2)
    let submitButtonColors = [Color(hex: 0x6c0eb2), Color(hex: 0x450674)]
    let disabledColor = Color(hex: 0xdedede)
    let borderColor = Color(hex: 0xdedede)
    let logControlColor = Color(hex: 0xdedede)
    let logsBackgroundColor = Color(hex: 0x2c3e50)
    let shadowColor = Color(hex: 0xffffff).opacity(0.1)

    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }

    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
}

extension View {
    func listShadow(_ theme: Theme) -> some View {
        let shadow = theme.listShadow
        return self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func tabBarBackgroundShadow(_ theme: Theme) -> some View {
        let shadow = theme.tabBarBackgroundShadow
        return self.background(theme.background.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
    }
}

//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI

extension Color: Codable {
    public init(from decoder: Decoder) throws {
        try self.init(hex: String(from: decoder))
    }
    
    public func encode(to encoder: Encoder) throws {
        try hex().encode(to: encoder)
    }
}

protocol Theme: Codable {
    typealias Shadow = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    
    var background: Color { get set }
    var textColor: Color { get set }
    var textColorLight: Color { get set }
    var accentColor: Color { get set }
    var accentColorLight: Color { get set }
    var linkColor: Color { get set }
    var submitButtonColor1: Color { get set }
    var submitButtonColor2: Color { get set }
    var disabledColor: Color { get set }
    var borderColor: Color { get set }
    var logControlColor: Color { get set }
    var logsBackgroundColor: Color { get set }
    var shadowColor: Color { get set }
    var listShadow: Shadow { get }
    var tabBarBackgroundShadow: Shadow { get }
    
    func save()
}

enum ThemeHelper {
    static var current: Theme {
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        if let sheme = ColorScheme(style) {
            return theme(for: sheme)
        }
        return LightTheme()
    }
    
    static func theme(for colorScheme: ColorScheme) -> Theme {
        if colorScheme == .dark {
            return UserDefaults.standard.darkTheme ?? DarkTheme()
        } else {
            return UserDefaults.standard.lightTheme ?? LightTheme()
        }
    }
}

struct LightTheme: Theme, Equatable {
    var background: Color = .white
    var textColor = Color(hex: 0x351d48)
    var textColorLight = Color(hex: 0x351d48).opacity(0.6)
    var accentColor = Color(hex: 0x4a2e5c)
    var accentColorLight = Color(hex: 0x4a2e5c).opacity(0.6)
    var linkColor = Color(hex: 0x6c0eb2)
    var submitButtonColor1 = Color(hex: 0x6c0eb2)
    var submitButtonColor2 = Color(hex: 0x450674)
    var disabledColor = Color(hex: 0xdedede)
    var borderColor = Color(hex: 0xdedede)
    var logControlColor = Color(hex: 0xdedede)
    var logsBackgroundColor = Color(hex: 0x2c3e50)
    var shadowColor = Color(hex: 0x0).opacity(0.1)

    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }
    
    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
    
    func save() {
        UserDefaults.standard.lightTheme = self
    }
}

struct DarkTheme: Theme, Equatable {
    var background = Color(hex: 0x2c3e50)
    var textColor = Color.white
    var textColorLight = Color.white.opacity(0.6)
    var accentColor = Color.green
    var accentColorLight = Color.green.opacity(0.6)
    var linkColor = Color(hex: 0x6c0eb2)
    var submitButtonColor1 = Color(hex: 0x6c0eb2)
    var submitButtonColor2 = Color(hex: 0x450674)
    var disabledColor = Color(hex: 0xdedede)
    var borderColor = Color(hex: 0xdedede)
    var logControlColor = Color(hex: 0xdedede)
    var logsBackgroundColor = Color(hex: 0x2c3e50)
    var shadowColor = Color(hex: 0xffffff).opacity(0.1)

    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }

    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
    
    func save() {
        UserDefaults.standard.darkTheme = self
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

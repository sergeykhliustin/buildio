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

public struct Theme: Codable, Equatable {
    typealias Shadow = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    
    static let lightTheme = [
        "accentColor": "#492D5B",
        "accentColorLight": "#492D5B99",
        "background": "#FEFEFE",
        "borderColor": "#DEDEDE",
        "disabledColor": "#DEDEDE",
        "linkColor": "#6C0EB2",
        "logControlColor": "#DEDEDE",
        "logsBackgroundColor": "#2C3D50",
        "shadowColor": "#00000019",
        "submitButtonColor1": "#6C0EB2",
        "submitButtonColor2": "#450673",
        "textColor": "#341D47",
        "textColorLight": "#341D4799"
    ]
    
    static let darkTheme = [
        "accentColor": "#33C758",
        "accentColorLight": "#33C75899",
        "background": "#2C3D50",
        "borderColor": "#DEDEDE",
        "disabledColor": "#DEDEDE",
        "linkColor": "#6C0EB2",
        "logControlColor": "#DEDEDE",
        "logsBackgroundColor": "#2C3D50",
        "shadowColor": "#FEFEFE19",
        "submitButtonColor1": "#6C0EB2",
        "submitButtonColor2": "#450673",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99"
    ]
    
    init(colorScheme: ColorScheme) {
        if colorScheme == .dark {
            try! self.init(from: Self.darkTheme)
        } else {
            try! self.init(from: Self.lightTheme)
        }
    }
    
    static var current: Theme {
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        if let sheme = ColorScheme(style) {
            return theme(for: sheme)
        }
        return Theme(colorScheme: .light)
    }
    
    static func theme(for colorScheme: ColorScheme) -> Theme {
        if colorScheme == .dark {
            return UserDefaults.standard.darkTheme ?? Theme(colorScheme: .dark)
        } else {
            return UserDefaults.standard.lightTheme ?? Theme(colorScheme: .light)
        }
    }
    
    var background: Color
    var textColor: Color
    var textColorLight: Color
    var accentColor: Color
    var accentColorLight: Color
    var linkColor: Color
    var submitButtonColor1: Color
    var submitButtonColor2: Color
    var disabledColor: Color
    var borderColor: Color
    var logControlColor: Color
    var logsBackgroundColor: Color
    var shadowColor: Color

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

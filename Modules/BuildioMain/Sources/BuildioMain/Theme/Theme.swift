//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI

extension ColorScheme: RawRepresentable, Codable {
    public typealias RawValue = String
    public init?(rawValue: String) {
        if rawValue.lowercased() == "light" {
            self = .light
        } else if rawValue.lowercased() == "dark" {
            self = .dark
        } else {
            logger.error("unsupported scheme")
            return nil
        }
    }
    
    public var rawValue: String {
        return self == .light ? "light" : "dark"
    }
}

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
        "scheme": "light",
        
        "accentColor": "#440C59",
        "accentColorLight": "#492D5B5F",
        "background": "#FEFEFE",
        "borderColor": "#ADADADA7",
        "controlsColor": "#454545",
        "disabledColor": "#ADADAD",
        "fadeColor": "#84848425",
        "linkColor": "#6C0EB2",
        "logControlColor": "#6E6F6F",
        "logsBackgroundColor": "#000000",
        "navigationColor": "#2D063C",
        "separatorColor": "#DEDEDE",
        "shadowColor": "#EAEAEA",
        "submitButtonColor1": "#E292FE",
        "submitButtonColor2": "#440C59",
        "textColor": "#000000",
        "textColorLight": "#341D4799",
        "abortButtonColor1": "#982ABC",
        "abortButtonColor2": "#450673"
    ]
    
    static let darkTheme = [
        "scheme": "dark",
        
        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#000000",
        "borderColor": "#999999",
        "controlsColor": "#CDCDCD",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#ADADAD",
        "logControlColor": "#5B5B5B",
        "logsBackgroundColor": "#000000",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FEFFFF00",
        "submitButtonColor1": "#982ABC",
        "submitButtonColor2": "#450673",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99",
        "abortButtonColor1": "#982ABC",
        "abortButtonColor2": "#450673"
    ]
    
    private init(colorScheme: ColorScheme) {
        if colorScheme == .dark {
            try! self.init(from: Self.darkTheme)
        } else {
            try! self.init(from: Self.lightTheme)
        }
    }
    
    static var current: Theme {
        let style = UIScreen.main.traitCollection.userInterfaceStyle
        let themeSettings = UserDefaults.standard.themeSettings
        switch themeSettings {
        case .light:
            return theme(for: .light)
        case .dark:
            return theme(for: .dark)
        case .system:
            if let sheme = ColorScheme(style) {
                return theme(for: sheme)
            }
            return Theme(colorScheme: .light)
        }
    }
    
    static func theme(for colorScheme: ColorScheme) -> Theme {
        if colorScheme == .dark {
            return UserDefaults.standard.darkTheme ?? Theme(colorScheme: .dark)
        } else {
            return UserDefaults.standard.lightTheme ?? Theme(colorScheme: .light)
        }
    }
    
    var scheme: ColorScheme
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
    var separatorColor: Color
    var logControlColor: Color
    var logsBackgroundColor: Color
    var shadowColor: Color
    var navigationColor: Color
    var fadeColor: Color
    var controlsColor: Color
    var abortButtonColor1: Color
    var abortButtonColor2: Color

    var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }
    
    var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
    
    func save() {
        if self.scheme == .light {
            UserDefaults.standard.lightTheme = self
        } else {
            UserDefaults.standard.darkTheme = self
        }
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

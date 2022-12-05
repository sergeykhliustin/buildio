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
    public typealias Shadow = (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat)
    
    private static let defaultLightTheme = [
        "name": "Default",
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
        "abortButtonColor1": "#FF8C82",
        "abortButtonColor2": "#831100"
    ]
    
    private static let defaultDarkTheme = [
        "name": "Sea Green",
        "scheme": "dark",
        
        "abortButtonColor1": "#FE8646",
        "abortButtonColor2": "#3C3300",
        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#003037",
        "borderColor": "#999999",
        "controlsColor": "#06ADCE",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#06ADCE",
        "logControlColor": "#5B5B5B",
        "logsBackgroundColor": "#201B22",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FFFFFF18",
        "submitButtonColor1": "#00C7FC",
        "submitButtonColor2": "#253E0F",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99"
    ]
    
    private static let annDarkTheme = [
        "name": "Ann Dark",
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
        "logsBackgroundColor": "#201B22",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FEFFFF00",
        "submitButtonColor1": "#982ABC",
        "submitButtonColor2": "#450673",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99",
        "abortButtonColor1": "#FF4014",
        "abortButtonColor2": "#710E00"
    ]
    
    private static let khndzTheme = [
        "name": "Khndz Dark",
        "scheme": "dark",
        
        "abortButtonColor1": "#FE8646",
        "abortButtonColor2": "#B51A00",
        "accentColor": "#FEFFFF",
        "accentColorLight": "#99999999",
        "background": "#000000",
        "borderColor": "#999999",
        "controlsColor": "#FEFFFF",
        "disabledColor": "#999999",
        "fadeColor": "#FFFFFF26",
        "linkColor": "#06ADCE",
        "logControlColor": "#5B5B5B",
        "logsBackgroundColor": "#201B22",
        "navigationColor": "#EAEAEA",
        "separatorColor": "#848484",
        "shadowColor": "#FFFFFF18",
        "submitButtonColor1": "#00C7FC",
        "submitButtonColor2": "#003549",
        "textColor": "#FEFEFE",
        "textColorLight": "#FEFEFE99"
    ]
    
    private static let themes = [
        Self.defaultLightTheme,
        Self.defaultDarkTheme,
        Self.annDarkTheme,
        Self.khndzTheme
    ]
    
    public static let defaultDarkName: String = "Sea Green"
    public static let defaultLightName = "Default"
    
    // swiftlint:disable force_try
    public static var current: Theme {
        let style: ColorScheme
        if let overrideInterfaceStyle = ProcessInfo.processInfo.env[.OverrideInterfaceStyle] {
            style = overrideInterfaceStyle == "dark" ? .dark : .light
        } else {
            style = UserDefaults.standard.colorSchemeSettings.colorScheme ?? ColorScheme.current
        }
        let lightThemeName = UserDefaults.standard.lightThemeName ?? defaultLightName
        let darkThemeName = UserDefaults.standard.darkThemeName ?? defaultDarkName
        switch style {
        case .dark:
            let theme = themes.first(where: { $0["scheme"] == "dark" && $0["name"] == darkThemeName }) ?? defaultDarkTheme
            return try! Theme(from: theme)
        default:
            let theme = themes.first(where: { $0["scheme"] == "light" && $0["name"] == lightThemeName }) ?? defaultLightTheme
            return try! Theme(from: theme)
        }
    }
    
    public static func defaultTheme(for colorScheme: ColorScheme) -> Theme {
        if colorScheme == .dark {
            let theme = themes.first(where: { $0["scheme"] == "dark" && $0["name"] == defaultDarkName }) ?? defaultDarkTheme
            return try! Theme(from: theme)
        } else {
            let theme = themes.first(where: { $0["scheme"] == "light" && $0["name"] == defaultLightName }) ?? defaultLightTheme
            return try! Theme(from: theme)
        }
    }
    // swiftlint:enable force_try
    
    public static func defaultName(for colorScheme: ColorScheme) -> String {
        if colorScheme == .dark {
            return defaultDarkName
        } else {
            return defaultLightName
        }
    }
    
    public static func themeNames(for scheme: ColorScheme) -> [String] {
        if scheme == .dark {
            return Self.themes.filter({ $0["scheme"] == "dark" }).map({ $0["name"]! })
        } else {
            return Self.themes.filter({ $0["scheme"] == "light" }).map({ $0["name"]! })
        }
    }
    
    public var name: String
    public var scheme: ColorScheme
    public var background: Color
    public var textColor: Color
    public var textColorLight: Color
    public var accentColor: Color
    public var accentColorLight: Color
    public var linkColor: Color
    public var submitButtonColor1: Color
    public var submitButtonColor2: Color
    public var disabledColor: Color
    public var borderColor: Color
    public var separatorColor: Color
    public var logControlColor: Color
    public var logsBackgroundColor: Color
    public var shadowColor: Color
    public var navigationColor: Color
    public var fadeColor: Color
    public var controlsColor: Color
    public var abortButtonColor1: Color
    public var abortButtonColor2: Color

    public var listShadow: Shadow {
        return (shadowColor, 10, 0, 0)
    }
    
    public var tabBarBackgroundShadow: Shadow {
        return (shadowColor, 3, 0, -5)
    }
}

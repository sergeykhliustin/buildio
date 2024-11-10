//
//  View+tabBarShadow.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//
import SwiftUI
import Assets

package extension View {
    func tabBarBackgroundShadow(_ theme: ThemeType) -> some View {
        let shadow = theme.tabBarBackgroundShadow
        return self.background(theme.background.color.shadow(color: shadow.color.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
    }
}

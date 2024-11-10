//
//  View+listShadow.swift
//  Modules
//
//  Created by Sergii Khliustin on 03.11.2024.
//

import SwiftUI
import Assets

package extension View {
    func listShadow(_ theme: ThemeType) -> some View {
        let shadow = theme.listShadow
        return self.shadow(color: shadow.color.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}

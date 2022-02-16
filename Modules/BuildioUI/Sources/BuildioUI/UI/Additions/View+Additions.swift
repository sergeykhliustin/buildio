//
//  View+Additions.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI
import BuildioLogic

extension View {
    var hosting: UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func listShadow(_ theme: Theme) -> some View {
        let shadow = theme.listShadow
        return self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    func tabBarBackgroundShadow(_ theme: Theme) -> some View {
        let shadow = theme.tabBarBackgroundShadow
        return self.background(theme.background.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y))
    }
    
    func defaultHorizontalPadding() -> some View {
        self.padding(.horizontal, 16)
    }

}

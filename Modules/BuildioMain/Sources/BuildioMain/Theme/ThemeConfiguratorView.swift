//
//  SwiftUIView.swift
//  
//
//  Created by Sergey Khliustin on 15.12.2021.
//

import SwiftUI

struct ThemeConfiguratorView<Content: View>: View {
    @Environment(\.theme) var theme
    @ViewBuilder private let content: () -> Content
    init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .introspectViewController { controller in
                controller.applyTheme(theme)
            }
    }
}

extension UIViewController {
    func applyTheme(_ theme: Theme) {
        view.backgroundColor = theme.background.uiColor
        
        if let navigation = self as? UINavigationController {
            let navigationBar = navigation.navigationBar
            navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
            navigationBar.compactAppearance = UINavigationBar.appearance().compactAppearance
            navigationBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
        }
        
        children.forEach({ $0.applyTheme(theme) })
        presentedViewController?.applyTheme(theme)
    }
}

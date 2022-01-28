//
//  ThemeSelectScreenView.swift
//  
//
//  Created by Sergey Khliustin on 28.01.2022.
//

import Foundation
import SwiftUI

struct ThemeSelectScreenView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: Navigator
    
    private let colorScheme: ColorScheme
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    var body: some View {
        let names = Theme.themeNames(for: colorScheme)
        let name = UserDefaults.standard.themeName(for: colorScheme) ?? Theme.defaultName(for: colorScheme)
        VStack(spacing: 8) {
            ForEach(names, id: \.self) { item in
                CheckmarkSettingsItem(title: item, selected: item == name, action: {
                    UserDefaults.standard.setThemeName(item, for: colorScheme)
                    DispatchQueue.main.async {
                        navigator.dismiss()
                    }
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(theme.background)
        .padding(.vertical, 8)
        .navigationTitle("Preferred theme")
    }
}

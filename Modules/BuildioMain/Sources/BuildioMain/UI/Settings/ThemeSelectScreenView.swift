//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct ThemeSelectScreenView: View {
    @AppStorage(UserDefaults.Keys.theme) private var themeSettings: ThemeSettings = .system
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(ThemeSettings.allCases) { item in
                CheckmarkSettingsItem(title: item.rawValue, icon: "", selected: item == themeSettings, action: {
                    themeSettings = item
                    navigator.dismiss()
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(theme.background)
        .padding(.vertical, 8)
        .navigationTitle("Preferred color scheme")
    }
}

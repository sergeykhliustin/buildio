//
//  ColorSchemeSelectScreenView.swift
//  
//
//  Created by Sergey Khliustin on 26.01.2022.
//

import SwiftUI

struct ColorSchemeSelectScreenView: View {
    @AppStorage(UserDefaults.Keys.theme) private var colorSchemeSettings: UserDefaults.ColorSchemeSettings = .system
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(UserDefaults.ColorSchemeSettings.allCases) { item in
                CheckmarkSettingsItem(title: item.rawValue, selected: item == colorSchemeSettings, action: {
                    colorSchemeSettings = item
                    DispatchQueue.main.async {
                        navigator.dismiss()
                    }
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(theme.background)
        .padding(.vertical, 8)
        .navigationTitle("Preferred color scheme")
    }
}

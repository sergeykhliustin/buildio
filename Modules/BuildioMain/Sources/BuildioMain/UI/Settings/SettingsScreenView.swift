//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(\.theme) private var theme
    @AppStorage(UserDefaults.Keys.debugMode) private var debugModeActive: Bool = false
    @AppStorage(UserDefaults.Keys.theme) private var themeSettings: ThemeSettings = .system
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack(spacing: 8) {
            NavigateSettingsItem(title: "Preferred color scheme", icon: "eyedropper.halffull", subtitle: themeSettings.rawValue, action: {
                navigator.go {
                    ThemeSelectScreenView()
                }
            })
            NavigateSettingsItem(title: "About", icon: "info", action: {})
                
            if debugModeActive {
                NavigateSettingsItem(title: "Debug", icon: "bolt.heart", action: {
                    navigator.go(.debug)
                })
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(theme.background)
        .onTapGesture(count: 10, perform: {
            debugModeActive.toggle()
        })
        .padding(.vertical, 8)
        .navigationTitle("Settings")
    }
}

struct SettingsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenView()
    }
}

//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(\.theme) private var theme
    @AppStorage("debugModeActive") private var debugModeActive: Bool = false
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack(spacing: 8) {
            IconActionItem(title: "Tune light theme", icon: "eyedropper.halffull") {
                navigator.go(.themeLight)
            }
            
            IconActionItem(title: "Tune dark theme", icon: "eyedropper.halffull") {
                navigator.go(.themeDark)
            }
            
            IconActionItem(title: "About", icon: "info", action: {})
                .overlay(Rectangle().fill(Color.white.opacity(0.01)).onTapGesture(count: 10, perform: {
                    debugModeActive.toggle()
                }))
            if debugModeActive {
                IconActionItem(title: "Debug", icon: "bolt.heart", action: {
                    navigator.go(.debug)
                })
            }
        }
        .frame(maxHeight: .infinity)
        .background(theme.background)
        .padding(.bottom, 8)
        .navigationTitle("Settings")
    }
}

struct SettingsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenView()
    }
}

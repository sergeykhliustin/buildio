//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI
import BuildioLogic

struct SettingsScreenView: View {
    @Environment(\.theme) private var theme
    @AppStorage(UserDefaults.Keys.debugMode) private var debugModeActive: Bool = false
    @AppStorage(UserDefaults.Keys.theme) private var colorSchemeSettings: UserDefaults.ColorSchemeSettings = .system
    @AppStorage(UserDefaults.Keys.darkThemeName) private var darkThemeName = Theme.defaultDarkName
    @AppStorage(UserDefaults.Keys.lightThemeName) private var lightThemeName = Theme.defaultLightName
    @AppStorage(UserDefaults.Keys.pollingInterval) private var pollingInterval = 30.0
    @AppStorage(UserDefaults.Keys.matchingPipelineMuted) private var matchingPipelineMuted = false
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Notifications")
                    .section()
                ToggleSettingsItem(title: "Mute all 'no matching pipeline found*' notifications", icon: nil, toggle: $matchingPipelineMuted)
                Text("Color settings")
                    .section()
                NavigateSettingsItem(
                    title: "Preferred appearance",
                    subtitle: colorSchemeSettings.rawValue,
                    action: {
                        navigator.go(.appearance)
                    })
                NavigateSettingsItem(
                    title: "Theme for dark appearance",
                    subtitle: darkThemeName,
                    action: {
                        navigator.go(.darkTheme)
                    })
                #if targetEnvironment(macCatalyst)
                Text("Buildio requests updates in the background with this interval. Slide to zero to disable")
                    .section()
                SliderSettingsItem(title: "Polling interval", value: $pollingInterval)
                #endif
                Text("-").section()
                NavigateSettingsItem(title: "About", action: {
                    navigator.go(.about)
                })
                
                if debugModeActive {
                    NavigateSettingsItem(title: "Debug", action: {
                        navigator.go(.debug)
                    })
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.vertical, 8)
        }
        .background(theme.background)
        .onTapGesture(count: 10, perform: {
            debugModeActive.toggle()
        })
    }
}

struct SettingsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreenView()
    }
}

//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI

struct DebugScreenView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        let analytics = UserDefaults.standard.backgroundAnalytics
        let analyticsText = analytics.keys.sorted().map({ "\($0): \(analytics[$0]!)" }).joined(separator: "\n")
        ScrollView {
            VStack(spacing: 8) {
                ListItemWrapper {
                    VStack(spacing: 8) {
                        Text("Background processing calls")
                        Text(analyticsText)
                            .font(.footnote)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
                IconActionItem(title: "Logs", icon: "doc.plaintext") {
                    navigator.go(.debugLogs)
                }
                IconActionItem(title: "Reset UserDefaults", icon: "clear", action: {
                    UserDefaults.standard.reset()
                })
                ToggleActionItem(title: "Disable screen dim",
                                 icon: "clear",
                                 toggle: Binding(get: { UIApplication.shared.isIdleTimerDisabled }, set: { newValue in UIApplication.shared.isIdleTimerDisabled = newValue }))
                IconActionItem(title: "Tune light theme", icon: "eyedropper.halffull") {
                    navigator.go(.themeLight)
                }
                
                IconActionItem(title: "Tune dark theme", icon: "eyedropper.halffull") {
                    navigator.go(.themeDark)
                }
            }
            .padding(.vertical, 8)
        }
        .background(theme.background)
        .navigationTitle("Debug")
    }
}

struct DebugScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DebugScreenView()
    }
}

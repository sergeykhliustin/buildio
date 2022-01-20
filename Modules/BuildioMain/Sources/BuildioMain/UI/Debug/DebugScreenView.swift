//
//  DebugScreenView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 18.11.2021.
//

import SwiftUI

struct DebugScreenView: View {
    @EnvironmentObject private var navigator: Navigator
    
    var body: some View {
        VStack(spacing: 8) {
            IconActionItem(title: "Logs", icon: "doc.plaintext") {
                navigator.go(.debugLogs)
            }
            IconActionItem(title: "Tune theme", icon: "eyedropper.halffull") {
                navigator.go(.theme)
            }
            IconActionItem(title: "Reset UserDefaults", icon: "clear", action: {
                UserDefaults.standard.reset()
            })
            ToggleActionItem(title: "Disable screen dim",
                             icon: "clear",
                             toggle: Binding(get: { UIApplication.shared.isIdleTimerDisabled }, set: { newValue in UIApplication.shared.isIdleTimerDisabled = newValue }))
        }
        .padding(.bottom, 8)
        .navigationTitle("Debug")
    }
}

struct DebugScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DebugScreenView()
    }
}

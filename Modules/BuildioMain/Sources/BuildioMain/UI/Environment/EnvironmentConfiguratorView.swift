//
//  EnvironmentConfiguratorView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

enum WindowMode {
    case compact
    case split
}

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

private struct KeyboardEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct DemoModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var fullscreen: Binding<Bool> {
        get {
            self[FullscreenEnvironmentKey.self]
        }
        set {
            self[FullscreenEnvironmentKey.self] = newValue
        }
    }
    
    var keyboard: Bool {
        get {
            self[KeyboardEnvironmentKey.self]
        }
        set {
            self[KeyboardEnvironmentKey.self] = newValue
        }
    }
    
    var isDemoMode: Binding<Bool> {
        get {
            self[DemoModeEnvironmentKey.self]
        }
        set {
            self[DemoModeEnvironmentKey.self] = newValue
        }
    }
}

public struct EnvironmentConfiguratorView<Content: View>: View {
    @StateObject var navigators = Navigators()
    @State private var fullscreen: Bool = false
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    @ViewBuilder let content: () -> Content
    @State private var isDemoMode: Bool = false
    
    public init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environment(\.fullscreen, $fullscreen)
            .environment(\.keyboard, keyboard.isVisible)
            .environmentObject(navigators)
            .environment(\.isDemoMode, $isDemoMode)
            .onChange(of: isDemoMode) { newValue in
                if newValue {
                    TokenManager.shared.setupDemo()
                } else {
                    TokenManager.shared.exitDemo()
                }
            }
    }
}

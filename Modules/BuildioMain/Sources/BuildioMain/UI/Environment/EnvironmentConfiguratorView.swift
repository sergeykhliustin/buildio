//
//  EnvironmentConfiguratorView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

private struct KeyboardEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
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
}

public struct EnvironmentConfiguratorView<Content: View>: View {
    let navigationHelper = NavigationHelper()
    @State private var fullscreen: Bool = false
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    @ViewBuilder let content: () -> Content
    
    public init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .environment(\.fullscreen, $fullscreen)
            .environment(\.keyboard, keyboard.isVisible)
            .environmentObject(navigationHelper)
    }
}

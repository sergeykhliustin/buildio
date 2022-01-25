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
    @StateObject var navigators: Navigators
    @State private var fullscreen: Bool = false
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    @ViewBuilder let content: () -> Content
    
    private let activityWatcher: ActivityWatcher
    private weak var screenFactory: ScreenFactory!
    private weak var tokenManager: TokenManager!
    
    public init(_ content: @escaping () -> Content) {
        self.content = content
        
        let tokenManager = TokenManager()
        let viewModelFactory = ViewModelFactory(tokenManager)
        let screenFactory = ScreenFactory(viewModelFactory)
        let navigators = Navigators(screenFactory)
        
        self.screenFactory = screenFactory
        self.tokenManager = tokenManager
        self.activityWatcher = ActivityWatcher(tokenManager)
        _navigators = StateObject(wrappedValue: navigators)
    }
    
    public var body: some View {
        content()
            .environment(\.fullscreen, $fullscreen)
            .environment(\.keyboard, keyboard.isVisible)
            .environmentObject(navigators)
            .environmentObject(screenFactory)
            .environmentObject(tokenManager)
    }
}

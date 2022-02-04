//
//  EnvironmentConfiguratorView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import UserNotifications
import BuildioLogic

public enum WindowMode {
    case compact
    case split
}

private struct FullscreenEnvironmentKey: EnvironmentKey {
    static var defaultValue: Binding<Bool> = .constant(false)
}

private struct KeyboardEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

private struct WindowModeEnvironmentKey: EnvironmentKey {
    static var defaultValue: WindowMode = .compact
}

private struct PreviewEnvironmentKey: EnvironmentKey {
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
    
    var windowMode: WindowMode {
        get {
            self[WindowModeEnvironmentKey.self]
        }
        set {
            self[WindowModeEnvironmentKey.self] = newValue
        }
    }
    
    var previewMode: Bool {
        get {
            self[PreviewEnvironmentKey.self]
        }
        set {
            self[PreviewEnvironmentKey.self] = newValue
        }
    }
}

public struct EnvironmentConfiguratorView<Content: View>: View {
    @StateObject private var keyboard: KeyboardObserver = KeyboardObserver()
    @StateObject private var navigators: Navigators
    @State private var fullscreen: Bool = false
    @State private var windowMode: WindowMode = .compact
    @Environment(\.scenePhase) private var scenePhase
    
    @ViewBuilder let content: () -> Content
    
    private let previewMode: Bool
    
    private let activityWatcher: ActivityWatcher?
    private weak var screenFactory: ScreenFactory!
    private weak var tokenManager: TokenManager!
    
    init(previewMode: Bool = false, _ content: @escaping () -> Content) {
        self.previewMode = previewMode
        self.content = content
        
        let tokenManager = previewMode ? PreviewTokenManager() : TokenManager()
        let viewModelFactory = ViewModelFactory(tokenManager)
        let screenFactory = ScreenFactory(viewModelFactory)
        let navigators = Navigators(screenFactory)
        
        self.screenFactory = screenFactory
        self.tokenManager = tokenManager
        self.activityWatcher = ActivityWatcher(tokenManager)
        _navigators = StateObject(wrappedValue: navigators)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            content()
                .environment(\.previewMode, previewMode)
                .environment(\.fullscreen, $fullscreen)
                .environment(\.keyboard, keyboard.isVisible)
                .environment(\.windowMode, windowMode)
                .environmentObject(navigators)
                .environmentObject(screenFactory)
                .environmentObject(tokenManager)
                .onAppear(perform: {
                    updateWindowMode(geometry)
                })
                .onChange(of: geometry.size) { _ in
                    updateWindowMode(geometry)
                }
                .onChange(of: scenePhase) { newValue in
                    logger.info("ScenePhase: \(newValue)")
                    if newValue == .active {
                        let center = UNUserNotificationCenter.current()
                        center.removeAllDeliveredNotifications()
                        center.removeAllPendingNotificationRequests()
                        activityWatcher?.resume()
                    } else {
                        activityWatcher?.pause()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "NSApplicationDidBecomeActiveNotification")), perform: { _ in
                    logger.info("NSApplicationDidBecomeActiveNotification")
                    activityWatcher?.resume()
                })
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "NSApplicationWillResignActiveNotification"))) { _ in
                    logger.info("NSApplicationWillResignActiveNotification")
                    activityWatcher?.pause()
                }
        }
    }
    
    private func updateWindowMode(_ geometry: GeometryProxy) {
        guard !previewMode else {
            windowMode = .compact
            return
        }
        if geometry.size.width > SplitNavigationController.Constants.primaryWidth * 2 + CustomTabBar.Constants.horizontalWidth {
            windowMode = .split
        } else {
            windowMode = .compact
        }
    }
}

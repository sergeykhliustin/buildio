//
//  NavigationModifier.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//
import SwiftUI
import SwiftUIIntrospect
import Logger

#if canImport(AppKit)
import AppKit
#endif

struct Introspector: ViewModifier {
    @Environment(\.theme) private var theme

    func body(content: Content) -> some View {
        content
#if targetEnvironment(macCatalyst)
            .introspect(.window, on: .iOS(.v16, .v17, .v18)) { window in

                window.backgroundColor = theme.background
                let titlebar = window.windowScene?.titlebar
                titlebar?.titleVisibility = .hidden
                titlebar?.toolbar = nil
                titlebar?.separatorStyle = .none
            }
#endif
    }
}

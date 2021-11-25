//
//  MainSecondaryOptionalView.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct MainSecondaryOptionalView<MainContent: View, SecondaryContent: View>: View {
    enum Orientation {
        case hMainSecondary
        case hSecondaryMain
        case vMainSecondary
        case vSecondaryMain
    }
    let orientation: Orientation
    let isSecondaryVisible: Bool
    let main: () -> MainContent
    let secondary: () -> SecondaryContent
    
    init(orientation: Orientation, isSecondaryVisible: Bool, main: @escaping () -> MainContent, secondary: @escaping () -> SecondaryContent) {
        self.orientation = orientation
        self.isSecondaryVisible = isSecondaryVisible
        self.main = main
        self.secondary = secondary
    }
    
    var body: some View {
        switch orientation {
        case .hMainSecondary:
            HStack(spacing: 0) {
                main()
                secondaryIfVisible()
            }
        case .hSecondaryMain:
            HStack(spacing: 0) {
                secondaryIfVisible()
                main()
            }
        case .vMainSecondary:
            VStack(spacing: 0) {
                main()
                secondaryIfVisible()
            }
        case .vSecondaryMain:
            VStack(spacing: 0) {
                secondaryIfVisible()
                main()
            }
        }
    }
    
    @ViewBuilder
    private func secondaryIfVisible() -> some View {
        if isSecondaryVisible {
            secondary()
        }
    }
}

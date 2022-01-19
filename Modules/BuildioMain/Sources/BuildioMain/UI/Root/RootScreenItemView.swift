//
//  RootScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreenItemView: View {
    @Environment(\.theme) var theme
    let type: RootScreenItemType
    
    init(_ type: RootScreenItemType) {
        self.type = type
    }
    
    var body: some View {
        let builder = ScreenBuilder.self
        switch type {
        case .builds:
            builder.buildsScreen(app: nil)
        case .apps:
            builder.appsScreen()
        case .accounts:
            builder.accountsScreen()
        case .activities:
            builder.activitiesScreen()
        case .debug:
            builder.debugScreen()
        }
    }
}

struct RootScreenItemView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenItemView(.debug)
    }
}

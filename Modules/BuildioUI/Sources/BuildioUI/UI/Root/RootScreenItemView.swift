//
//  RootScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootScreenItemView: ScreenBuilder {
    let type: RootScreenItemType
    
    init(_ type: RootScreenItemType) {
        self.type = type
    }
    
    var body: some View {
        switch type {
        case .builds:
            buildsScreen(app: nil)
        case .apps:
            appsScreen()
        case .accounts:
            accountsScreen()
        case .activities:
            activitiesScreen()
        case .debug:
            debugScreen()
        }
    }
}

struct RootScreenItemView_Previews: PreviewProvider {
    static var previews: some View {
        RootScreenItemView(.debug)
    }
}

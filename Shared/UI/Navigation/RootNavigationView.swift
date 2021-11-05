//
//  RootNavigationView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.10.2021.
//

import SwiftUI

struct RootNavigationView: View {
    init() {
        #if os(iOS)
        UITabBar.appearance().isHidden = true
        #endif
    }
    var body: some View {
//        TabsScreenView()
        CustomTabsScreenView()
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}

//
//  RootNavigationView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct RootNavigationView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            BuildsScreenView()
                .onTapGesture {
                    selectedTab = 0
                }
                .tabItem {
                    Text("Builds")
                }.tag(0)
            ProfileScreenView()
                .onTapGesture {
                    selectedTab = 1
                }
                .tabItem {
                    Text("Profile")
                }.tag(1)
        }
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}

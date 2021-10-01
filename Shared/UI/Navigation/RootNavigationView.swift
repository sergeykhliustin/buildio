//
//  RootNavigationView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct RootNavigationView: View {
    var body: some View {
        TabView {
            BuildsView().tabItem {
                Text("Builds")
            }
            ProfileView().tabItem {
                Text("Profile")
            }
        }
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}

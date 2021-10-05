//
//  TabsScreenView.swift
//  Buildio
//
//  Created by severehed on 05.10.2021.
//

import SwiftUI

struct TabsScreenView: View {
    @Binding var showSideMenu: Bool
    @State private var selectedTab = 0
    var body: some View {
        ZStack(alignment: .topLeading) {
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
            Button {
                withAnimation {
                    showSideMenu = true
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
            }
            .frame(width: 44, height: 44, alignment: .center)
        }
    }
}

struct TabsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TabsScreenView(showSideMenu: .constant(false))
    }
}

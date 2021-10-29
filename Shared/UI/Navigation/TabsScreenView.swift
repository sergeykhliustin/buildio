//
//  TabsScreenView.swift
//  Buildio
//
//  Created by severehed on 05.10.2021.
//

import SwiftUI

struct TabsScreenView: View {
    @State private var selectedTab = 0
    
    init() {
        #if os(iOS)
        UITabBar.appearance().backgroundColor = .white
        #endif
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    BuildsScreenView()
                        .navigationTitle("Builds")
                }
                .onAppear {
                    selectedTab = 0
                }
                .tag(0)
                .tabItem {
                    Image(systemName: "hammer.fill")
                    Text("Builds")
                }
                
                NavigationView {
                    AppsScreenView()
                        .navigationTitle("Apps")
                }
                .onAppear {
                    selectedTab = 1
                }
                .tag(1)
                .tabItem {
                    Image(systemName: "apps.iphone")
                    Text("Apps")
                }
                
                NavigationView {
                    AccountsScreenView()
                        .navigationTitle("Accounts")
                        
                }
                .onAppear {
                    selectedTab = 2
                }
                .tag(2)
                .tabItem {
                    Image(systemName: "ellipsis.rectangle")
                    Text("Accounts")
                }
                
                NavigationView {
                    ProfileScreenView()
                        .navigationTitle("Profile")
                }
                .onAppear {
                    selectedTab = 3
                }
                .tag(3)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
            }

        }
    }
}

struct TabsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TabsScreenView()
    }
}

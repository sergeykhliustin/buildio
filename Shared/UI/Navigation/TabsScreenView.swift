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
    
    init(showSideMenu: Binding<Bool>) {
        self._showSideMenu = showSideMenu
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TabView(selection: $selectedTab) {
                NavigationView {
                    BuildsScreenView()
                        .navigationTitle("Builds")
                        .onTapGesture {
                            selectedTab = 0
                        }
                        .toolbar {
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
                .tag(0)
                .tabItem {
                    Image(systemName: "hammer.fill")
                    Text("Builds")
                }
                
                AccountsScreenView()
                    .onTapGesture {
                        selectedTab = 1
                    }
                    .tag(1)
                    .tabItem {
                        Image(systemName: "ellipsis.rectangle")
                        Text("Accounts")
                    }
                
                ProfileScreenView()
                    .onTapGesture {
                        selectedTab = 2
                    }
                    .tag(2)
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
        TabsScreenView(showSideMenu: .constant(false))
    }
}

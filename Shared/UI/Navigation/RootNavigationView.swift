//
//  RootNavigationView.swift
//  Buildio
//
//  Created by severehed on 01.10.2021.
//

import SwiftUI

struct RootNavigationView: View {
    @State var showSideMenu: Bool = false
    @State private var gestureOffset: CGFloat = 0
    private let sideMenuWidth = 0.5
    
    var body: some View {
        let dragGesture = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        showSideMenu = false
                        gestureOffset = 0
                    }
                } else {
                    withAnimation {
                        gestureOffset = 0
                    }
                }
            }
            .onChanged {
                gestureOffset = $0.translation.width
            }
        GeometryReader { geometry in
            Group {
                buildTabsScreen(geometry: geometry, gestureOffset: gestureOffset)
                if showSideMenu {
                    AccountsScreenView()
                        .frame(width: geometry.size.width * sideMenuWidth, height: geometry.size.height, alignment: .leading)
                        .offset(x: gestureOffset)
                        .transition(.move(edge: .leading))
                        .gesture(dragGesture)
                }
            }
            .gesture(dragGesture)
        }
    }
    
    @ViewBuilder
    private func buildTabsScreen(geometry: GeometryProxy, gestureOffset: CGFloat) -> some View {
        TabsScreenView(showSideMenu: $showSideMenu)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: showSideMenu ? geometry.size.width * sideMenuWidth + gestureOffset : 0)
            .disabled(showSideMenu)
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}

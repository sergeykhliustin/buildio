//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import Introspect
import UIKit

struct RootTabView: View {
    @Environment(\.theme) var theme
    @EnvironmentObject private var navigators: Navigators
    
    @Binding private var selection: Int
    private let configuration: [RootScreenItemType]
    
    init(selection: Binding<Int>, configuration: [RootScreenItemType] = RootScreenItemType.default) {
        self._selection = selection
        self.configuration = configuration
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<configuration.count) { index in
                let item = configuration[index]
                SplitNavigationView(shouldSplit: item.splitNavigation) {
                    RootScreenItemView(item)
                        .navigationTitle(item.name)
                }
                .ignoresSafeArea()
                .environmentObject(navigators.navigator(for: item))
                .tag(index)
                
            }
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(selection: .constant(0))
    }
}

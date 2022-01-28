//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import UIKit

struct RootTabView: View {
    @Environment(\.previewMode) private var previewMode
    @Environment(\.theme) private var theme
    @EnvironmentObject private var navigators: Navigators
    
    @Binding private var selection: Int
    
    init(selection: Binding<Int>) {
        self._selection = selection
    }
    
    var body: some View {
        let configuration = previewMode ? RootScreenItemType.preview : RootScreenItemType.default
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

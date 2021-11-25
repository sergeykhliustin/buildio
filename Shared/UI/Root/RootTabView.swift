//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI

struct RootTabView: View {
    @Environment(\.fullscreen) private var fullscreen
    @Binding private var selection: Int
    private let configuration: [RootScreenItemType]
    
    init(selection: Binding<Int>, configuration: [RootScreenItemType] = RootScreenItemType.default) {
        self._selection = selection
        self.configuration = configuration
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(configuration, id: \.rawValue) { item in
                if item.navigation {
                    NavigationView {
                        RootScreenItemView(item)
                            .background(Color.white)
                            .navigationTitle(item.name)
                    }
                    .introspectSplitViewController { splitViewController in
                        logger.debug(splitViewController)
                        splitViewController.preferredSplitBehavior = .tile
                        splitViewController.primaryBackgroundStyle = .none
                        splitViewController.minimumPrimaryColumnWidth = 300
                        splitViewController.maximumPrimaryColumnWidth = 600
                        
                        if !fullscreen.wrappedValue {
                            splitViewController.preferredDisplayMode = .oneOverSecondary
                        }
                        
                        if fullscreen.wrappedValue && splitViewController.displayMode != .secondaryOnly {
                            splitViewController.hide(.primary)
                        }
                    }
                } else {
                    RootScreenItemView(item)
                }
            }
        }
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView(selection: .constant(0))
    }
}

//
//  RootTabViewScreen.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 25.11.2021.
//

import SwiftUI
import Introspect

private extension View {
    typealias ContentTransform<Content: View> = (Self) -> Content

    @ViewBuilder
    func conditionalModifier<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        ifTrue: ContentTransform<TrueContent>,
        ifFalse: ContentTransform<FalseContent>
    ) -> some View {
        if condition {
            ifTrue(self)
        } else {
            ifFalse(self)
        }
    }
}

struct RootTabView: View {
    @Environment(\.fullscreen) private var fullscreen
    
    @Binding private var selection: Int
    private let configuration: [RootScreenItemType]
    
    init(selection: Binding<Int>, configuration: [RootScreenItemType] = RootScreenItemType.default) {
        self._selection = selection
        self.configuration = configuration
    }
    
    private var isStack: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<configuration.count) { index in
                let item = configuration[index]
                if item.navigation {
                    NavigationView {
                        RootScreenItemView(item)
                            .background(Color.white)
                            .navigationTitle(item.name)
                    }
                    .conditionalModifier(
                        isStack,
                        ifTrue: { $0.navigationViewStyle(.stack) },
                        ifFalse: { $0.navigationViewStyle(.automatic) }
                    )
                    .tag(index)
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
                        .tag(index)
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

//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 09.12.2021.
//

import SwiftUI
import Introspect

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    /// Finds a `UISplitViewController` from  a `SwiftUI.NavigationView` with style `DoubleColumnNavigationViewStyle`.
    public func introspectSplitViewController(customize: @escaping (UISplitViewController) -> Void) -> some View {
            inject(UIKitIntrospectionViewController(
                selector: { introspectionViewController in
                    
                    // Search in ancestors
                    if let splitViewController = introspectionViewController.splitViewController {
                        return splitViewController
                    }
                    
                    // Search in siblings
                    return Introspect.previousSibling(containing: UISplitViewController.self, from: introspectionViewController)
                },
                customize: customize
            ))
        }
}

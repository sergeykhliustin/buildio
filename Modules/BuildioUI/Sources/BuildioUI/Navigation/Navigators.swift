//
//  Navigators.swift
//  
//
//  Created by Sergey Khliustin on 01.12.2021.
//

import Foundation
import SwiftUI
import Combine

final class Navigators: ObservableObject {
    @Published var isPresentingModal: Bool = false
    private var navigators = NSMapTable<NSString, Navigator>(valueOptions: .weakMemory)
    private let screenFactory: ScreenFactory
    
    init(_ screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
    }
    
    public func navigator(for type: RootScreenItemType) -> Navigator {
        if let navigator = navigators.object(forKey: type.id as NSString) {
            return navigator
        } else {
            let navigator = Navigator(self, factory: screenFactory)
            navigators.setObject(navigator, forKey: type.id as NSString)
            return navigator
        }
    }
    
    public func updatePresenting() {
        withAnimation {
            isPresentingModal = (navigators.objectEnumerator()?.allObjects ?? []).compactMap({ $0 as? Navigator }).map({ $0.isPresentingSheet }).contains(true)
        }
    }
    
    func popToRoot(type: RootScreenItemType) {
        navigator(for: type).popToRoot()
    }
    
    func popToRootAll() {
        RootScreenItemType.allCases.forEach({ popToRoot(type: $0) })
    }
}

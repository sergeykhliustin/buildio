//
//  NavigationHelper.swift
//  
//
//  Created by Sergey Khliustin on 01.12.2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class NavigationHelper: ObservableObject {
    private var navigationControllers = NSMapTable<NSString, UINavigationController>(valueOptions: .weakMemory)
    private var splitControllers = NSMapTable<NSString, UISplitViewController>(valueOptions: .weakMemory)
    
    func set(navigation: UINavigationController, for type: RootScreenItemType) {
        navigationControllers.setObject(navigation, forKey: type.id as NSString)
    }
    
    func set(split: UISplitViewController, for type: RootScreenItemType) {
        splitControllers.setObject(split, forKey: type.id as NSString)
    }
    
    func getNavigation(for type: RootScreenItemType) -> UINavigationController? {
        navigationControllers.object(forKey: type.id as NSString)
    }
    
    func getSplit(for type: RootScreenItemType) -> UISplitViewController? {
        splitControllers.object(forKey: type.id as NSString)
    }
    
    func popToRoot(type: RootScreenItemType) {
        navigationControllers.object(forKey: type.id as NSString)?.popToRootViewController(animated: true)
        guard let splitController = splitControllers.object(forKey: type.id as NSString) else { return }
        if let navigation = splitController.viewController(for: .secondary) as? UINavigationController {
            let hosting = UIHostingController(rootView: EmptyView())
            navigation.setViewControllers([hosting], animated: false)
            logger.debug(navigation)
        }
    }
    
    func popToRootAll() {
        RootScreenItemType.allCases.forEach({ popToRoot(type: $0) })
    }
}

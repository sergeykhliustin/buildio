//
//  Navigators.swift
//  
//
//  Created by Sergey Khliustin on 01.12.2021.
//

import Foundation
import UIKit
import SwiftUI
import Combine

final class Navigators: ObservableObject {
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
    
    func popToRoot(type: RootScreenItemType) {
        navigationControllers.object(forKey: type.id as NSString)?.popToRootViewController(animated: true)
        guard let splitController = splitControllers.object(forKey: type.id as NSString) else { return }
        if let navigation = splitController.viewController(for: .secondary) as? UINavigationController {
            let hosting = EmptyHostingController()
            navigation.setViewControllers([hosting], animated: false)
            
            logger.debug(navigation)
        }
    }
    
    func popToRootAll() {
        RootScreenItemType.allCases.forEach({ popToRoot(type: $0) })
    }
    
    private func fixEmptyNavigation(type: RootScreenItemType) {
        guard let navigation = navigationControllers.object(forKey: type.id as NSString) else { return }
        if navigation.viewControllers.contains(where: { childController in
            (childController as? UINavigationController)?.viewControllers.contains(where: { $0 is EmptyHostingController }) == true
        }) {
            navigation.popToRootViewController(animated: false)
        }
        logger.debug(navigation)
    }
    
    func fixEmptyNavigation() {
        RootScreenItemType.allCases.forEach({ fixEmptyNavigation(type: $0) })
    }
    
    func applyTheme(_ theme: Theme) {
        RootScreenItemType.allCases.forEach({
            guard let navigation = navigationControllers.object(forKey: $0.id as NSString) else { return }
            
            let navigationBar = navigation.navigationBar
            navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
            navigationBar.compactAppearance = UINavigationBar.appearance().compactAppearance
            navigationBar.scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance
            
        })
    }
}

private final class EmptyHostingController: UIHostingController<EmptyView> {
    init() {
        super.init(rootView: EmptyView())
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

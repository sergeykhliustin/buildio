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
    private var navigators = NSMapTable<NSString, Navigator>(valueOptions: .weakMemory)
    
    public func navigator(for type: RootScreenItemType) -> Navigator {
        if let navigator = navigators.object(forKey: type.id as NSString) {
            return navigator
        } else {
            let navigator = Navigator()
            navigators.setObject(navigator, forKey: type.id as NSString)
            return navigator
        }
    }
    
    func popToRoot(type: RootScreenItemType) {
        navigator(for: type).popToRoot()
    }
    
    func popToRootAll() {
        RootScreenItemType.allCases.forEach({ popToRoot(type: $0) })
    }
}

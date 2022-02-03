//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 19.01.2022.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension Array where Element == NSLayoutConstraint {
    func relatedTo(view: UIView) -> [NSLayoutConstraint] {
        return filter({ $0.firstItem as? UIView == view || $0.secondItem as? UIView == view })
    }
    
    func notRelatedTo(view: UIView) -> [NSLayoutConstraint] {
        return filter({ $0.firstItem as? UIView != view && $0.secondItem as? UIView != view })
    }
}

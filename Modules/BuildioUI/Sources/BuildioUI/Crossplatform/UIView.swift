//
//  UIView.swift
//  
//
//  Created by Sergey Khliustin on 04.02.2022.
//

#if os(macOS)
import AppKit
import BuildioLogic
typealias UIView = NSView

extension NSView {
    var backgroundColor: UIColor? {
        get {
            if let color = layer?.backgroundColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}
#endif

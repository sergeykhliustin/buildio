//
//  MacStatusBarPlugin.swift
//  MacStatusBarPlugin
//
//  Created by Sergey Khliustin on 01.02.2022.
//

import Foundation
import AppKit
import BuildioUI

final class MacStatusBarPlugin: NSObject, MacStatusBarPluginProtocol {
    var statusItem: NSStatusItem!
    var actionHandler: ((MacStatusBarPluginActions) -> Void)!
    
    required convenience init(_ actionHandler: @escaping (MacStatusBarPluginActions) -> Void) {
        self.init()
        self.actionHandler = actionHandler
    }
    
    required override init() {
        super.init()
    }
    
    func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let image = Bundle(for: Self.self).image(forResource: "icon") {
            statusItem.button?.image = image
        }
        setupMenus()
    }
    
    func setupMenus() {
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        let one = NSMenuItem(title: "New window", action: #selector(didTapOne), keyEquivalent: "n")
        one.target = self
        menu.addItem(one)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc private func didTapOne() {
        actionHandler(.newWindow)
    }
}

//
//  MacStatusBarPlugin.swift
//  MacStatusBarPlugin
//
//  Created by Sergey Khliustin on 01.02.2022.
//

import Foundation
import AppKit
import SwiftUI
import Cocoa

final class MacStatusBarPlugin: NSObject, MacStatusBarPluginProtocol {
    var statusItem: NSStatusItem!
    var actionHandler: ((MacStatusBarPluginActions, Any?, Any?) -> Void)!
    var popover: NSPopover!
//    var controller: NSViewController!
    var view: Any!
    
    required convenience init(_ actionHandler: @escaping (MacStatusBarPluginActions, Any?, Any?) -> Void) {
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
            statusItem.button?.target = self
            statusItem.button?.action = #selector(showPopover)
        }
//        setupMenus()
    }
    
    @objc private func showPopover() {
        if let button = statusItem.button {
            actionHandler(.newWindow, button.bounds, button)
        }
        return
        popover = NSPopover()
        let hosting = NSHostingController(rootView: Text(""))
        popover.contentViewController = hosting
        popover.behavior = .transient
        popover.animates = true
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
        }
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
        
    }
}

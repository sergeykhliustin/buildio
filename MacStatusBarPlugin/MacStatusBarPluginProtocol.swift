//
//  MacStatusBarPluginProtocol.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.02.2022.
//

import Foundation

@objc(MacStatusBarPluginProtocol)
protocol MacStatusBarPluginProtocol: NSObjectProtocol {
    init(_ actionHandler: @escaping (MacStatusBarPluginActions) -> Void)
    
    func setup()
}

@objc(MacStatusBarPluginActions)
enum MacStatusBarPluginActions: Int {
    case newWindow
}

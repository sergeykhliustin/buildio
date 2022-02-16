//
//  MacStatusBarPluginProtocol.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.02.2022.
//

import Foundation
import SwiftUI

@objc(MacStatusBarPluginProtocol)
protocol MacStatusBarPluginProtocol: NSObjectProtocol {
    var view: Any! { get set }
    init(_ actionHandler: @escaping (MacStatusBarPluginActions, Any?, Any?) -> Void)
    
    func setup()
}

@objc(MacStatusBarPluginActions)
enum MacStatusBarPluginActions: Int {
    case newWindow
}

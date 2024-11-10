//
//  PlatformColor.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

#if os(macOS)
package typealias PlatformColor = NSColor
#else
import UIKit
package typealias PlatformColor = UIColor
#endif

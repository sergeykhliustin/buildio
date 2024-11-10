//
//  ViewRepresentable.swift
//  Modules
//
//  Created by Sergii Khliustin on 07.11.2024.
//

import SwiftUI

#if os(iOS)
package typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
package typealias ViewRepresentable = NSViewRepresentable
#endif

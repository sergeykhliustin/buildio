//
//  View+Multiplatform.swift
//  Buildio
//
//  Created by severehed on 29.10.2021.
//

import Foundation
import SwiftUI

extension View {
    func multiplatformButtonStylePlain() -> some View {
        #if os(iOS)
        return self.buttonStyle(.plain)
        #else
        return self
        #endif
    }
}

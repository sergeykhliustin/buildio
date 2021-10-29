//
//  NavigationLink+Multiplatform.swift
//  Buildio
//
//  Created by severehed on 29.10.2021.
//

import Foundation
import SwiftUI

extension NavigationLink where Label == Text, Destination: View {
    init<V: Hashable>(@ViewBuilder multiplatformDestination: () -> Destination, tag: V, selection: Binding<V?>) {
        #if os(iOS)
//        self.init(tag: tag, selection: selection, destination: multiplatformDestination, label: { EmptyView() })
        self.init("", tag: tag, selection: selection, destination: multiplatformDestination)
        #elseif os(macOS)
        self.init("", destination: multiplatformDestination(), tag: tag, selection: selection)
        #endif
    }
}

extension NavigationLink {
    init(@ViewBuilder multiplatformDestination: () -> Destination, @ViewBuilder label: () -> Label) {
        #if os(iOS)
        self.init(destination: multiplatformDestination, label: label)
        #elseif os(macOS)
        self.init(destination: multiplatformDestination(), label: label)
        #endif
    }
}

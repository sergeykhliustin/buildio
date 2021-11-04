//
//  Image+Multiplatform.swift
//  Buildio
//
//  Created by Sergey Khliustin on 04.11.2021.
//

import SwiftUI

extension Image {
    init(_ image: UIImage) {
        #if os(iOS)
        self.init(uiImage: image)
        #elseif os(macOS)
        self.init(nsImage: image)
        #endif
    }
}

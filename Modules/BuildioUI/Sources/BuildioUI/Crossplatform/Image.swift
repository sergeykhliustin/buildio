//
//  Image.swift
//  
//
//  Created by Sergey Khliustin on 04.02.2022.
//

#if os(macOS)
import SwiftUI
import BuildioLogic

extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif

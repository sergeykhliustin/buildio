//
//  RightButtonModifier.swift
//  Buildio (iOS)
//
//  Created by Sergey Khliustin on 09.11.2021.
//

import Foundation
import SwiftUI

struct RightButtonModifier: ViewModifier {
    var action: () -> Void
    let icon: Images
    let loading: Bool
    
    init(icon: Images, loading: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
        self.loading = loading
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if loading {
                ProgressView()
                    .padding(.trailing, 16)
            } else {
                Button(action: action, label: {
                    Image(icon)
                })
                    .padding(.trailing, 16)
            }
        }
    }
}

//
//  PlaceholderTextField.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import Foundation
import SwiftUI
import UIKit

struct PlaceholderTextField: ViewModifier {
    @Environment(\.theme) private var theme
    let placeholder: String
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content.placeholder(when: text.isEmpty) {
            Text(placeholder)
                .foregroundColor(theme.textColorLight)
        }
    }
    
}

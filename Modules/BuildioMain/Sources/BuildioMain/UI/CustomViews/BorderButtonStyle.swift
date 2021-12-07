//
//  BorderButtonStyle.swift
//  
//
//  Created by Sergey Khliustin on 03.12.2021.
//

import Foundation
import SwiftUI

struct BorderButtonStyle: ButtonStyle {
    var padding: CGFloat = 4
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration
                .label
                .padding(padding)
        }
        .background(RoundedRectangle(cornerRadius: 4).stroke(configuration.isPressed ? Color.b_ButtonPrimary : Color.b_BorderLight, lineWidth: 1))
        .contentShape(Rectangle())
    }
}

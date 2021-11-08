//
//  PasteButton.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import Foundation
import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack(alignment: .center, spacing: 2) {
            content
            
            if !text.isEmpty {
                Button {
                    self.text = ""
                } label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color.b_ButtonPrimaryLight)
                }
                .background(Color.white)
            }
        }
    }
    
}

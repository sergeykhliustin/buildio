//
//  PasteButton.swift
//  Buildio
//
//  Created by Sergey Khliustin on 21.10.2021.
//

import Foundation
import SwiftUI
import UIKit

struct PasteButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if text.isEmpty {
                Button {
                    if let pb = UIPasteboard.general.string {
                        text = pb
                    }
                } label: {
                    Image(systemName: "doc.on.clipboard.fill")
                        .foregroundColor(Color.b_ButtonPrimaryLight)
                }
                .background(Color.white)
                .padding(.trailing, 8)
            }
        }
    }
    
}

//
//  PasteButton.swift
//  Buildio
//
//  Created by severehed on 21.10.2021.
//

import Foundation
import SwiftUI
#if !os(macOS)
import UIKit
#endif

struct PasteButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            
            if text.isEmpty {
                Button {
                    #if os(macOS)
                    if let pb = NSPasteboard.general.string(forType: .string) {
                        text = pb
                    }
                    #else
                    if let pb = UIPasteboard.general.string {
                        text = pb
                    }
                    #endif
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

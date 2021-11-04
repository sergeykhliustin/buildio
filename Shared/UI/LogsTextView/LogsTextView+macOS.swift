//
//  TextView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation
import SwiftUI

struct LogsTextView: NSViewRepresentable {
    var attributed: NSAttributedString?
    
    func makeNSView(context: Context) -> NSTextView {
        let view = NSTextView()
        view.backgroundColor = UIColor(Color.b_LogsBackground)
        return view
    }
    
    func updateNSView(_ uiView: NSTextView, context: Context) {
        if let attributed = attributed {
            uiView.textStorage?.setAttributedString(attributed)
        }
        
        scrollToBottom(textView: uiView)
    }
    
    private func scrollToBottom(textView: NSTextView) {
        let attributed = textView.attributedString()
        let bottom = NSRange(location: attributed.length - 1, length: 1)
        if attributed.length > 0 {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                textView.scrollRangeToVisible(bottom)
            }
        }
    }
}

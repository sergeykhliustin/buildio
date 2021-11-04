//
//  TextView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation
import UIKit
import SwiftUI

struct LogsTextView: UIViewRepresentable {
    var attributed: NSAttributedString?
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.autocorrectionType = .no
        view.backgroundColor = UIColor(Color.b_LogsBackground)
        view.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributed
        scrollToBottom(textView: uiView)
    }
    
    private func scrollToBottom(textView: UITextView) {
        if textView.attributedText.length > 0 {
            let location = textView.attributedText.length - 1
            let bottom = NSRange(location: location, length: 1)
            UIView.animate(withDuration: 0.2) {
                textView.scrollRangeToVisible(bottom)
            }
        }
    }
}

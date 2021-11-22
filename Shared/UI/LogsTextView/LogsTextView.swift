//
//  TextView.swift
//  Buildio
//
//  Created by Sergey Khliustin on 01.11.2021.
//

import Foundation
import SwiftUI
import UIKit

struct LogsTextView: UIViewRepresentable {
    var attributed: NSAttributedString?
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isOpaque = false
        textView.clipsToBounds = false
        textView.isEditable = false
        textView.indicatorStyle = .black
        textView.autocorrectionType = .no
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8.5)
        textView.backgroundColor = UIColor(Color.b_LogsBackground)
        textView.textColor = UIColor.white
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: -8),
            view.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: 8),
            view.topAnchor.constraint(equalTo: textView.topAnchor),
            view.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let textView = uiView.subviews.first(where: { $0 is UITextView }) as? UITextView else { return }
        textView.attributedText = attributed
        scrollToBottom(textView: textView)
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

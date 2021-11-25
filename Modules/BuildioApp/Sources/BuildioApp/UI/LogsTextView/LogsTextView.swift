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
    @Binding var follow: Bool
    @Binding var selectedRange: NSRange?
    @Binding var attributed: NSAttributedString?
    
    private var scrollViewDelegate: ScrollViewDelegate
    
    init(follow: Binding<Bool>, selectedRange: Binding<NSRange?>, attributed: Binding<NSAttributedString?>) {
        self._follow = follow
        self._selectedRange = selectedRange
        self._attributed = attributed
        scrollViewDelegate = ScrollViewDelegate(onScroll: {
            follow.wrappedValue = false
        })
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(Color.b_LogsBackground)
        let textView = UITextView()
        textView.delegate = scrollViewDelegate
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isOpaque = false
        textView.clipsToBounds = false
        textView.isEditable = false
        textView.indicatorStyle = .white
        textView.autocorrectionType = .no
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8.5)
        textView.backgroundColor = UIColor(Color.b_LogsBackground)
        textView.textColor = UIColor.white
        
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: textView.leftAnchor, constant: -8),
            view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: textView.rightAnchor, constant: 8),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: textView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 40)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let textView = uiView.subviews.first(where: { $0 is UITextView }) as? UITextView else { return }
        textView.delegate = scrollViewDelegate
        textView.attributedText = attributed ?? NSAttributedString(string: "Loading logs...", attributes: [.foregroundColor: UIColor.white])
        scrollToBottom(textView: textView)
        selectRange(textView: textView)
    }
    
    private func selectRange(textView: UITextView) {
        guard let range = selectedRange else { return }
        guard let attributed = textView.attributedText else { return }
        
        if range.length > 0 {
            let mutable = NSMutableAttributedString(attributedString: attributed)
            mutable.addAttributes([
                .backgroundColor: UIColor.yellow,
                .foregroundColor: UIColor.black
            ], range: range)
            textView.attributedText = mutable
            textView.scrollRangeToVisible(range)
        }
    }
    
    private func scrollToBottom(textView: UITextView) {
        guard follow && selectedRange == nil else { return }
        
        DispatchQueue.main.async {
            if textView.attributedText.length > 0 {
                let location = textView.attributedText.length - 1
                let bottom = NSRange(location: location, length: 1)
                UIView.animate(withDuration: 0.1, animations: {
                    textView.scrollRangeToVisible(bottom)
                }, completion: { success in
                    if success {
                        let contentSize = textView.contentSize
                        let frameSize = textView.frame.size
                        if contentSize.height > frameSize.height {
                            textView.contentOffset = CGPoint(x: 0, y: contentSize.height - frameSize.height)
                        }
                    }
                })
            }
        }
    }
}

private final class ScrollViewDelegate: NSObject, UITextViewDelegate {
    let onScroll: () -> Void
    init(onScroll: @escaping () -> Void) {
        self.onScroll = onScroll
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onScroll()
    }
}

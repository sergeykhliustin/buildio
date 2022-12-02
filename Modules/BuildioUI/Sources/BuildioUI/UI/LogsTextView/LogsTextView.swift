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
    @Environment(\.theme) private var theme
    @Binding var follow: Bool
    @Binding var search: Bool
    private let attributed: NSAttributedString?
    private var scrollViewHandler: ScrollViewDelegate
    
    init(follow: Binding<Bool>, search: Binding<Bool>, attributed: NSAttributedString?) {
        self.attributed = attributed
        self._follow = follow
        self._search = search
        
        scrollViewHandler = ScrollViewDelegate(onScroll: {
            follow.wrappedValue = false
        })
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
        view.clipsToBounds = true
        view.backgroundColor = UIColor(theme.logsBackgroundColor)
        let textView = UITextView()
        textView.delegate = scrollViewHandler
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isOpaque = false
        textView.clipsToBounds = false
        textView.isEditable = false
        textView.indicatorStyle = .white
        textView.autocorrectionType = .no
        textView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8.5)
        textView.backgroundColor = UIColor(theme.logsBackgroundColor)
        textView.textColor = UIColor.white
        if #available(iOS 16.0, *) {
            textView.isFindInteractionEnabled = true
        }
        
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
        textView.delegate = scrollViewHandler
        textView.attributedText = attributed ?? NSAttributedString(string: "Loading logs...", attributes: [.foregroundColor: UIColor(Color.b_LogsDefault)])
        scrollToBottom(textView: textView)
        if search {
            textView.presentFind()
        } else {
            textView.dismissFind()
        }
    }
    
    private func scrollToBottom(textView: UITextView) {
        guard follow && !textView.isFindVisible else { return }
        DispatchQueue.main.async {
            if textView.attributedText.length > 0 {
                let location = textView.attributedText.length - 1
                let bottom = NSRange(location: location, length: 1)

                textView.scrollRangeToVisible(bottom)
                
                let contentSize = textView.contentSize
                let frameSize = textView.frame.size
                if contentSize.height > frameSize.height {
                    textView.contentOffset = CGPoint(x: 0, y: contentSize.height - frameSize.height)
                }
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

private extension UITextView {
    var isFindVisible: Bool {
        if #available(iOS 16.0, *) {
            return findInteraction?.isFindNavigatorVisible == true
        } else {
            return false
        }
    }

    func presentFind() {
        if #available(iOS 16.0, *) {
            findInteraction?.presentFindNavigator(showingReplace: false)
        }
    }

    func dismissFind() {
        if #available(iOS 16.0, *) {
            findInteraction?.dismissFindNavigator()
        }
    }
}

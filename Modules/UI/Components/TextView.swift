//
//  TextElement.swift
//  Modules
//
//  Created by Sergii Khliustin on 05.11.2024.
//

import Foundation
import SwiftUI

package struct TextView: ViewRepresentable {
    private let text: String

    package init(_ text: String) {
        self.text = text
    }

    #if os(macOS)
    package func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isSelectable = true
//        textView.font = context.environment.font?.nsFont
        textView.string = text
        return textView
    }

    package func updateNSView(_ nsView: NSTextView, context: Context) {
    }
    #endif

    #if os(iOS)
    package func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = context.environment.font?.uiFont
        textView.text = text
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = .all
        return textView
    }

    package func updateUIView(_ uiView: UITextView, context: Context) {
        let textView = uiView
        textView.font = context.environment.font?.uiFont
        textView.text = text
    }

    package func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width, width != .infinity, width != 0 else { return nil }
        let size = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return size
    }
    #endif
}

#if os(iOS)
private extension Font {
    var uiFont: UIFont {
        return UIFont.preferredFont(from: self)
    }
}

private extension UIFont {
    class func preferredFont(from font: Font) -> UIFont {
        let style: UIFont.TextStyle
        switch font {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body:        style = .body
        default:           style = .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}
#endif

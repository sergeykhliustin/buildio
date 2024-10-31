//
//  File.swift
//  
//
//  Created by Sergey Khliustin on 06.12.2022.
//

import Foundation
import SwiftUI

struct TextElement: View {
    private let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            TextView(text: content)
        } else {
            Text(content)
        }
    }
}

@available(iOS 16.0, *)
struct TextView: UIViewRepresentable {
    let text: String
    func makeUIView(context: Context) -> UITextView {
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

    func updateUIView(_ uiView: UITextView, context: Context) {
        let textView = uiView
        textView.font = context.environment.font?.uiFont
        textView.text = text
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width, width != .infinity, width != 0 else { return nil }
        let size = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return size
    }
}

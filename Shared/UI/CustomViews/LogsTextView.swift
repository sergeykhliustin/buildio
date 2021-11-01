//
//  TextView.swift
//  Buildio
//
//  Created by severehed on 01.11.2021.
//

import Foundation
import SwiftUI
import Rainbow

struct LogsTextView: UIViewRepresentable {
    var logChunks: [String]
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.autocorrectionType = .no
        view.backgroundColor = UIColor(Color.b_LogsBackground)
        view.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let attributed = logChunks.reduce(NSMutableAttributedString()) { partialResult, chunk in
            partialResult.append(chunkToAttributed(chunk))
            return partialResult
        }
        uiView.attributedText = attributed
        scrollToBottom(textView: uiView)
    }
    
    private func scrollToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSRange(location: location, length: 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
    private func chunkToAttributed(_ chunk: String) -> NSAttributedString {
        let entry = Rainbow.extractEntry(for: chunk)
        return entry.segments.reduce(NSMutableAttributedString()) { partialResult, segment in
            partialResult.append(segment.attributedString)
            return partialResult
        }
    }
}

private extension Rainbow.Segment {
    var attributedString: NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let background = self.backgroundColor, let color = Color.color(for: background) {
            attributes[.backgroundColor] = UIColor(color)
        }
        if let foreground = self.color, let color = Color.color(for: foreground) {
            attributes[.foregroundColor] = UIColor(color)
        } else {
            attributes[.foregroundColor] = UIColor(Color.b_LogsDefault)
        }
        for style in styles ?? [] {
            switch style {
            case .bold:
                attributes[.font] = UIFont.boldSystemFont(ofSize: 13)
            case .italic:
                attributes[.font] = UIFont.italicSystemFont(ofSize: 13)
            case .underline:
                attributes[.underlineStyle] = NSUnderlineStyle.single
            case .strikethrough:
                attributes[.strikethroughStyle] = NSUnderlineStyle.single
            default:
                break
            }
        }
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//
//  InternalWebView.swift
//  Modules
//
//  Created by Sergii Khliustin on 12.11.2024.
//

import Foundation
import SwiftUI
import WebKit

struct InternalWebView: UIViewRepresentable {
    let url: URL
    var customUserAgent: String?
    @Binding var progress: Double
    @Binding var title: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.customUserAgent = customUserAgent
        webView.allowsLinkPreview = true
        webView.navigationDelegate = context.coordinator
//        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: InternalWebView

        init(parent: InternalWebView) {
            self.parent = parent
        }
        // swiftlint:disable:next implicitly_unwrapped_optional
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.parent.progress = 1.0
            }
        }
        func webView(
            _ webView: WKWebView,
            // swiftlint:disable:next implicitly_unwrapped_optional
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            parent.progress = 0.0
        }
        // swiftlint:disable:next implicitly_unwrapped_optional
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.progress = Double(webView.estimatedProgress)
        }
    }
}

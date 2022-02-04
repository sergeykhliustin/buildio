//
//  AuthWebViewContoller.swift
//  
//
//  Created by Sergey Khliustin on 01.02.2022.
//

import Foundation
import SwiftUI
import WebKit

struct AuthWebViewContoller: UIViewControllerRepresentable {
    static let navigationTitle = "app.bitrise.io"
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = AuthWebViewUIWebViewController()
        return controller
    }
    
    func makeNSViewController(context: Context) -> some UIViewController {
        let controller = AuthWebViewUIWebViewController()
        return controller
    }
}

private final class AuthWebViewUIWebViewController: UIViewController {
    var webView: WKWebView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: webView.leftAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.rightAnchor.constraint(equalTo: webView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: "https://app.bitrise.io/me/profile#/security")!))
    }
}

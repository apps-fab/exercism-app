//
//  WebView.swift
//  Exercism
//
//  Created by Angie Mugo on 23/03/2023.
//

import SwiftUI
import AppKit
import WebKit

struct WebView: NSViewRepresentable {
    let urlString: String

    func makeNSView(context: Context) -> some NSView {
        let webView = WKWebView(frame: CGRect.zero)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let removeElementIdScript = "document.getElementsByClassName(\"c-track-header\")[0].style.display='none';"
            webView.evaluateJavaScript(removeElementIdScript) { (response, error) in
                if let response = response {
                    print("This is the response: \(response)")
                }
                if let error = error {
                    print("This is the error: \(error)")
                }
            }
        }
    }
}

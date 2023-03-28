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

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }

        return webView
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
}

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
    @Binding var dynamicHeight: CGFloat
    let urlString: String
    var webView = WKWebView()

    func makeNSView(context: Context) -> some NSView {
        let config = WKWebViewConfiguration()
        config.preferences.isElementFullscreenEnabled = true
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
        return Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.getCookies { cookies in
                print("These are the cookies: \(cookies)")
            }
            let removeElementIdScript = "document.getElementsByClassName(\"c-track-header\")[0].style.display='none';"
            DispatchQueue.main.async {
                webView.evaluateJavaScript(removeElementIdScript) { (response, error) in
                    if let response = response {
                        print("This is the response: \(response)")
                    }
                    if let error = error {
                        print("This is the error: \(error)")
                    }
                }
            }

            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }
}

extension WKWebView {

    private var httpCookieStore: WKHTTPCookieStore  { return WKWebsiteDataStore.default().httpCookieStore }

    func getCookies(for domain: String? = nil, completion: @escaping ([String : Any])->())  {
        var cookieDict = [String : AnyObject]()
        httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }
    }
}

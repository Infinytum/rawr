//
//  OnboardingMisskeyAuthModalController.swift
//  Derg Social
//
//  Created by Nila on 12.08.2023.
//

import WebKit

public class OnboardingMisskeyAuthModalController: UIViewController {
    var webView = WKWebView()
    private var continuation: CheckedContinuation<URL, Error>?

    required init?(coder: NSCoder) {
        fatalError("not supported")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
    }

    override public func loadView() {
        view = webView
    }
    
    func startSession(url: URL) {
        webView.load(URLRequest(url: url))
    }

    func result() async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
}

extension OnboardingMisskeyAuthModalController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.absoluteString.starts(with: "https://derg.social/rawr.redirect") {
            decisionHandler(.cancel)
            self.dismiss(animated: true) {
                self.continuation?.resume(returning: url)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true) {
            self.continuation?.resume(throwing: error)
        }
    }
}

extension OnboardingMisskeyAuthModalController {
    static func removeCookies() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

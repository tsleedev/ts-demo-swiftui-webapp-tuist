//
//  WebViewRepresentable+Coordinator.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSCrashlytics
import TSLogger
import TSUtility
import TSWebView
import Foundation
import WebKit

extension WebViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        // MARK: - Initialize with ViewModel
        private let viewModel: WebViewModel
        
        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
            super.init()
        }
        
        deinit {
            TSLogger.debug(self)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewRepresentable.Coordinator {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url, let scheme = url.scheme, !scheme.isEmpty else { return .cancel }
        
        let validSchemes: Set<String>
#if DEBUG
        validSchemes = ["http", "https", "about", "file"]
#else
        validSchemes = ["http", "https", "about"]
#endif
        if !validSchemes.contains(scheme) {
            if await UIApplication.shared.canOpenURL(url) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url)
                }
            }
            return .cancel
        }
        return .allow
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        return .allow
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        viewModel.setLoading(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.setLoading(false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        viewModel.setLoading(false)
    }
}

// MARK: - WKUIDelegate
extension WebViewRepresentable.Coordinator {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        viewModel.runJavaScriptAlertPanel(message: message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        viewModel.runJavaScriptConfirmPanel(message: message, completionHandler: completionHandler)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // TODO: 추후 필요하면 추가
    }
    
    func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        // TODO: 추후 필요하면 추가
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let webView = TSWebView(createWebViewWith: configuration)
            viewModel.newWebView(webView)
            return webView // webView return 없이 사용할 경우 웹의 부모창에서 자식창을 닫을 수 없음. webViewDidClose가 호출이 안됨
        }
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        guard let webview = webView as? TSWebView else { return }
        viewModel.popWebView(webview)
    }
}

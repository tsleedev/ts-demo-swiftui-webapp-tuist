//
//  WebViewRepresentable+Coordinator.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSCoreLogger
import TSCoreUtilities
import TSServiceCrashlytics
import TSUIWebView
import Foundation
import WebKit

extension WebViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate {
        // MARK: - Initialize with ViewModel
        private let webView: TSWebView
        private let viewModel: WebViewModel
        private var isDragging: Bool = false
        
        init(webView: TSWebView, viewModel: WebViewModel) {
            self.webView = webView
            self.viewModel = viewModel
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
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        guard let currentURL = webView.url,
              let newURL = navigationAction.request.url
        else { return nil }
        
#if DEBUG
        // DEBUG 모드에서 file:// URL 처리
        if currentURL.scheme == "file" {
            if currentURL.scheme == newURL.scheme {
                let webView = TSWebView(createWebViewWith: configuration)
                viewModel.newWebView(webView)
                return webView // webView return 없이 사용할 경우 웹의 부모창에서 자식창을 닫을 수 없음. webViewDidClose가 호출이 안됨
            } else {
                viewModel.requestExternalNavigation(to: newURL)
                return nil
            }
        }
#endif
        
        if let currentHost = currentURL.host,
           let newHost = newURL.host,
           currentHost == newHost {
            let webView = TSWebView(createWebViewWith: configuration)
            viewModel.newWebView(webView)
            return webView // webView return 없이 사용할 경우 웹의 부모창에서 자식창을 닫을 수 없음. webViewDidClose가 호출이 안됨
        } else {
            viewModel.requestExternalNavigation(to: newURL)
        }
        
        return nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        guard let webview = webView as? TSWebView else { return }
        viewModel.popWebView(webview)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WebViewRepresentable.Coordinator {
    @objc func handleDrag(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            let location = gesture.location(in: gesture.view)
            if viewModel.isGestureStartingOnLeftEdge(startLocationX: location.x) {
                isDragging = true
            } else {
                gesture.isEnabled = false
                gesture.isEnabled = true
            }
        case .changed:
            if !isDragging { return }
            let translation = gesture.translation(in: gesture.view)
            viewModel.updateOffset(for: webView, with: translation.x)
        case .ended, .cancelled:
            if !isDragging { return }
            let translation = gesture.translation(in: gesture.view)
            viewModel.handleSwipeGesture(for: webView, with: translation.x)
            isDragging = false
        default:
            break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 첫 번째 드래그 제스처가 활성화된 동안 다른 터치를 무시
        return !isDragging
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

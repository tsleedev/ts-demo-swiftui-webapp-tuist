//
//  WebViewRepresentable.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSUIWebView
import FeatureCommon
import SwiftUI

struct WebViewRepresentable<Coordinator: CoordinatorProtocol>: UIViewControllerRepresentable {
    // MARK: - Initialize with Coordinator
    private let coordinator: Coordinator
    private let startUrl: URL
    
    init(coordinator: Coordinator, startUrl: URL) {
        self.coordinator = coordinator
        self.startUrl = startUrl
    }
    
    func makeUIViewController(context: Context) -> FeatureWebViewController<Coordinator> {
        let webView = TSWebView()
        webView.load(url: startUrl)
        let viewController = FeatureWebViewController(coordinator: coordinator, webView: webView)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: FeatureWebViewController<Coordinator>, context: Context) {
        
    }
}

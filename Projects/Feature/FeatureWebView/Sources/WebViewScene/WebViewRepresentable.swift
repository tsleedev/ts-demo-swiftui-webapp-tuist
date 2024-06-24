//
//  WebViewRepresentable.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSUIWebView
import SwiftUI

struct WebViewRepresentable: UIViewRepresentable {
    // MARK: - Initialize with ViewModel
    private let viewModel: WebViewModel
    private let webView: TSWebView
    private let isSwipeBackGestureEnabled: Bool
    
    init(viewModel: WebViewModel, webView: TSWebView, isSwipeBackGestureEnabled: Bool = true) {
        self.viewModel = viewModel
        self.webView = webView
        self.isSwipeBackGestureEnabled = isSwipeBackGestureEnabled
    }
    
    func makeUIView(context: Context) -> TSWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        if isSwipeBackGestureEnabled {
            let dragGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDrag(_:)))
            dragGesture.delegate = context.coordinator
            webView.addGestureRecognizer(dragGesture)
        }
        
        return webView
    }

    func updateUIView(_ webView: TSWebView, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(webView: webView, viewModel: viewModel)
    }
}

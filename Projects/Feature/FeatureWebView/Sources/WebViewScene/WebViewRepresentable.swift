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
    
    init(viewModel: WebViewModel, webView: TSWebView) {
        self.viewModel = viewModel
        self.webView = webView
    }
    
    func makeUIView(context: Context) -> TSWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
}

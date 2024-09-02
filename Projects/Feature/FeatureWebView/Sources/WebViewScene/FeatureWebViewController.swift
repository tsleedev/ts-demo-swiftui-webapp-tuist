//
//  FeatureWebViewController.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 8/29/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSUIWebView
import FeatureCommon
import UIKit

class FeatureWebViewController<Coordinator: CoordinatorProtocol>: TSWebViewController {
    private let coordinator: Coordinator
    private var jsHandler: JavaScriptHandler<Coordinator>?
    
    init(coordinator: Coordinator, webView: TSWebView) {
        self.coordinator = coordinator
        super.init(webView: webView)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(type(of: self)) \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let jsHandler = JavaScriptHandler(coordinator: coordinator, webView: webView)
        webView.javaScriptEnable(target: jsHandler, protocol: JavaScriptInterface.self)
        self.jsHandler = jsHandler
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registerForAppStateNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForAppStateNotifications()
    }
    
    override func createWebViewController(webView: TSWebView) -> TSWebViewController {
        return FeatureWebViewController(coordinator: coordinator, webView: webView)
    }
    
    // MARK: - Actions
    @objc private func applicationDidEnterBackground() {
        webView.evaluateJavaScript("onAppBackground()", completion: nil)
    }
    
    @objc private func applicationWillEnterForeground() {
        webView.evaluateJavaScript("onAppForeground()", completion: nil)
    }
}

// MARK: - Notification
extension FeatureWebViewController {
    func registerForAppStateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func unregisterForAppStateNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

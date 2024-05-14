//
//  TSWebView.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/07/08.
//

import WebKit

class WebProgressPoolManager {
    static let shared = WebProgressPoolManager()
    var progressPoll = WKProcessPool()
    private init() {}
}

public protocol TSWebViewInteractionDelegate: AnyObject {
    func didReceiveMessage(name: String, body: Any)
}

open class TSWebView: WKWebView, WKScriptMessageHandler, Identifiable {
    public let id: String = UUID().uuidString
    
    public static var applictionNameForUserAgent: String = "TSWebView/1.0"
    public weak var interactionDelegate: TSWebViewInteractionDelegate?
    
    private weak var progressView: UIProgressView?
    private var progressObserver: NSKeyValueObservation?
    private var javaScriptController: TSJavaScriptController?
    
    public convenience init() {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.applicationNameForUserAgent = Self.applictionNameForUserAgent
        configuration.userContentController = userContentController
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes(rawValue: 0)
        configuration.processPool = WebProgressPoolManager.shared.progressPoll
        self.init(frame: .zero, configuration: configuration)
    }
    
    public convenience init(createWebViewWith configuration: WKWebViewConfiguration) {
        self.init(frame: .zero, configuration: configuration)
    }
    
    public override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    deinit {
        print("deinit \(self)")
        removeObserver()
    }
    
    private func initialize() {
        if #available(iOS 16.4, *) {
            isInspectable = true
        }
        createProgress()
        observeProgress()
    }
    
    // MARK: - Progress
    private func observeProgress() {
        progressObserver = observe(\.estimatedProgress, options: .new) { [weak self] _, change in
            guard let self = self,
                  let newValue = change.newValue
            else { return }
            let progress = Int(newValue * 100)
            progressView?.progress = Float(newValue)
            progressView?.isHidden = (progress >= 100)
        }
    }
    
    private func createProgress() {
        if progressView != nil { return }
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = UIColor.blue.withAlphaComponent(0.1)
        progressView.progressTintColor = UIColor.blue.withAlphaComponent(0.5)
        progressView.isHidden = true
        addSubview(progressView)
        if let superview = progressView.superview {
            progressView.translatesAutoresizingMaskIntoConstraints = false
            progressView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
            progressView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
            progressView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
            progressView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        }
        self.progressView = progressView
    }
}

public extension TSWebView {
    func removeObserver() {
        progressObserver?.invalidate()
        progressObserver = nil
    }
    
    func javaScriptEnable(target: AnyObject, protocol bridgeProtocol: Protocol) {
        let javaScriptController = TSJavaScriptController(target: target, bridgeProtocol: bridgeProtocol)
        setJavaScriptController(javaScriptController)
        self.javaScriptController = javaScriptController
    }
    
    func addScriptMessageHandler(names: [String]) {
        if names.isEmpty { return }
        let target = LeakAvoiderScriptMessageHandler(delegate: self)
        names.forEach { name in
            configuration.userContentController.add(target, name: name)
        }
    }
    
    @available(iOS 14.0, *)
    func removeAllScriptMessageHandlers() {
        configuration.userContentController.removeAllScriptMessageHandlers()
    }
    
    func removeScriptMessageHandler(names: [String]) {
        names.forEach { name in
            configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
    
    func load(urlString: String?) {
        guard let urlString = urlString else { return }
        if let url = URL(string: urlString) {
            load(url: url)
        }
    }
    
    func load(url: URL?) {
        guard let url = url else { return }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 35.0)
        load(request)
    }
    
    @objc func evaluateJavaScript(_ script: String?, completion: ((Any?, Error?) -> Void)? = nil) {
        guard let script = script, !script.isEmpty else { return }
        DispatchQueue.main.async {
            self.evaluateJavaScript(script) { (response, error) in
                if let error = error {
                    print("TSWebView evaluateJavaScript error = \(error)")
                }
                if let response = response {
                    print("TSWebView evaluateJavaScript response = \(response)")
                }
                
                completion?(response, error)
            }
        }
    }
}

// MARK: - WKScriptMessageHandler
extension TSWebView {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        interactionDelegate?.didReceiveMessage(name: message.name, body: message.body)
    }
}

//
//  WebViewModel.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSAnalytics
import TSLogger
import TSUtility
import TSWebView
import FeatureCommon
import SwiftUI

enum NavigationStyle: String {
    case push, replace, modal
}

struct WebViewState: Hashable {
    let identifier: UUID = UUID()
    let webView: TSWebView
    let afterCloseScript: String?
    
    init(webView: TSWebView, afterCloseScript: String?) {
        self.webView = webView
        self.afterCloseScript = afterCloseScript
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: WebViewState, rhs: WebViewState) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

final class WebViewModel: NSObject, ObservableObject {
    // MARK: - Published
    @Published var webViewStates: [WebViewState] = []
    @Published var offsets: [CGFloat] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Properties
    private let coordinator: CoordinatorProtocol
    
    // MARK: - Initialize
    init(coordinator: CoordinatorProtocol, webState: WebState) {
        self.coordinator = coordinator
        super.init()
        createWebView(url: webState.url, afterCloseScript: webState.afterCloseScript)
    }
    
    deinit {
        TSLogger.debug(self)
    }
}

// MARK: - Helper
private extension WebViewModel {
    func createWebView(url: URL, position: CGFloat = 0, afterCloseScript: String? = nil) {
        let webView = TSWebView()
        webView.addScriptMessageHandler(names: ScripMessageHandlerNames.allNames)
        webView.interactionDelegate = self
        webView.load(url: url)
        addWebView(webView: webView, position: position, afterCloseScript: afterCloseScript)
    }
    
    func addWebView(webView: TSWebView, position: CGFloat = 0, afterCloseScript: String? = nil) {
        let webViewState = WebViewState(webView: webView, afterCloseScript: afterCloseScript)
        webViewStates.append(webViewState)
        offsets.append(position)
    }
    
    func replaceWebView(webView: TSWebView, afterCloseScript: String? = nil) {
        var newWebViewStates = webViewStates
        newWebViewStates.removeLast()
        offsets.removeLast()
        let webViewState = WebViewState(webView: webView, afterCloseScript: afterCloseScript)
        newWebViewStates.append(webViewState)
        webViewStates = newWebViewStates
        offsets.append(0)
    }
    
    func removeWebViewState(af index: Int) {
        guard webViewStates[safe: index] != nil, offsets[safe: index] != nil else {
            print("Attempted to access out of range index: \(index)")
            return
        }
        let webViewState = webViewStates.remove(at: index)
        offsets.remove(at: index)
        if let afterCloseScript = webViewState.afterCloseScript {
            webViewStates.last?.webView.evaluateJavaScript(afterCloseScript)
        }
    }
}

// MARK: - Internal
extension WebViewModel {
    func setLoading(_ isLoading: Bool) {
//        Task {
            self.isLoading = isLoading
//            try await Task.sleep(nanoseconds: 2_000_000_000) // 2초 동안 지연
//        }
    }
    
    func newWebView(_ webView: TSWebView) {
        let screenWidth = UIScreen.main.bounds.width
        addWebView(webView: webView, position: screenWidth)
        let duration = animationDuration(currentOffset: screenWidth, appearing: true)
        resetOffset(for: offsets.endIndex - 1, duration: duration)
    }
    
    func newWebView(_ url: URL, afterCloseScript: String? = nil, style: NavigationStyle = .push) {
        switch style {
        case .push:
            let screenWidth = UIScreen.main.bounds.width
            createWebView(url: url, position: screenWidth, afterCloseScript: afterCloseScript)
            let duration = animationDuration(currentOffset: screenWidth, appearing: true)
            resetOffset(for: offsets.endIndex - 1, duration: duration)
        case .replace:
            let webView = TSWebView()
            webView.addScriptMessageHandler(names: ScripMessageHandlerNames.allNames)
            webView.interactionDelegate = self
            webView.load(url: url)
            replaceWebView(webView: webView, afterCloseScript: afterCloseScript)
        case .modal:
            coordinator.fullScreenCover(.webview(.init(url: url, afterCloseScript: afterCloseScript, completion: { [weak self] in
                guard let self = self else { return }
                if let afterCloseScript = afterCloseScript {
                    webViewStates.last?.webView.evaluateJavaScript(afterCloseScript)
                }
            })))
        }
    }
    
    func popWebView(_ webView: TSWebView) {
        guard webViewStates.count > 1,
              let index = webViewStates.firstIndex(where: { $0.webView == webView }), index != 0
        else { return }
        
        if index < webViewStates.endIndex - 1 { // 마지막 웹뷰가 아니면 웹뷰만 제거
            removeWebViewState(af: index)
        } else { // 마지막 웹뷰인 경우 애니메이션과 함께 제거
            let duration = animationDuration(currentOffset: 0, appearing: false)
            dismissView(for: index, duration: duration)
        }
    }
    
    func pop() {
        // 배열에 최소 두 개의 요소가 있을 경우에만 마지막 웹뷰 제거
        guard webViewStates.count > 1 else { return }
        let duration = animationDuration(currentOffset: 0, appearing: false)
        // 마지막 웹뷰인 경우 애니메이션과 함께 제거
        dismissView(for: webViewStates.endIndex - 1, duration: duration)
    }
    
    func popToRootWebView() {
        // 배열에 최소 두 개의 요소가 있을 경우에만 첫 웹뷰를 제외한 모든 웹뷰 제거
        guard webViewStates.count > 1 else { return }
        
        // 마지막 웹뷰 제외하고 모든 웹뷰 제거
        webViewStates.removeSubrange(1..<webViewStates.count - 1)
        offsets.removeSubrange(1..<offsets.count - 1)
        
        // 마지막 웹뷰에 대한 애니메이션 처리
        if let lastWebViewIndex = webViewStates.indices.last {
            let duration = animationDuration(currentOffset: 0, appearing: false)
            dismissView(for: lastWebViewIndex, duration: duration)
        }
    }
    
    func closeWebView() {
        coordinator.dismiss()
    }
    
    func revealSettings() {
        coordinator.push(.settings)
    }
    
    func runJavaScriptAlertPanel(message: String, completionHandler: @escaping () -> Void) {
        coordinator.alert(.init(message: message, completion: completionHandler))
    }
    
    func runJavaScriptConfirmPanel(message: String, completionHandler: @escaping (Bool) -> Void) {
        coordinator.confirm(.init(message: message, completion: completionHandler))
    }
}

// MARK: - Animation
extension WebViewModel {
    func updateOffset(for index: Int, with translation: CGFloat, startLocationX: CGFloat) {
        guard isGestureStaringOnLeftEdge(startLocationX: startLocationX) else { return }
        offsets[index] = translation
    }
    
    func handleSwipeGesture(for index: Int, with translationWidth: CGFloat, startLocationX: CGFloat) {
        guard isGestureStaringOnLeftEdge(startLocationX: startLocationX) else { return }
        let translationWidth = abs(translationWidth)
        if translationWidth > 100 {
            let duration = animationDuration(currentOffset: translationWidth, appearing: false)
            dismissView(for: index, duration: duration)
        } else {
            let duration = animationDuration(currentOffset: translationWidth, appearing: true)
            resetOffset(for: index, duration: duration)
        }
    }
    
    private func isGestureStaringOnLeftEdge(startLocationX: CGFloat) -> Bool {
        if webViewStates.count == 1 { return false } // 최상단 웹뷰는 지우지 않음
        let edgeWidth: CGFloat = 20.0 // 왼쪽 가장자기 범위 설정
        return startLocationX >= 0.0 && startLocationX <= edgeWidth
    }
    
    private func dismissView(for index: Int, duration: TimeInterval) {
        let offset = UIScreen.main.bounds.width
        if #available(iOS 17.0, *) {
            withAnimation(.easeOut(duration: duration)) {
                self.offsets[index] = offset
            } completion: {
                self.removeWebViewState(af: index)
            }
        } else {
            withAnimation(.easeOut(duration: duration)) {
                self.offsets[index] = offset
            }
            // 애니메이션이 끝나고 URL을 제거
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.removeWebViewState(af: index)
            }
        }
    }
    
    private func resetOffset(for index: Int, duration: TimeInterval) {
        withAnimation(.easeOut(duration: duration)) {
            offsets[index] = 0
        }
    }
    
    private func animationDuration(currentOffset: CGFloat, appearing: Bool) -> TimeInterval {
        let screenWidth = UIScreen.main.bounds.width
        let maxAnimationDuration: Double = 0.3 // 최대 애니메이션 시간
        let minAnimationDuration: Double = 0.1 // 최소 애니메이션 시간
        
        // 나타날 때는 전체 화면 너비에서 현재 위치를 뺀 거리륵 기준으로 계산
        // 사라질 때는 현재 오프셋을 직접 사용
        let effetiveDistance = appearing ? (screenWidth - currentOffset) : currentOffset
        let normalizedDistance = effetiveDistance / screenWidth
        
        let animationDuration = max(minAnimationDuration, (1 - normalizedDistance) * (maxAnimationDuration - minAnimationDuration) + minAnimationDuration)
        return animationDuration
    }
}

extension WebViewModel: TSWebViewInteractionDelegate {
    func didReceiveMessage(name: String, body: Any) {
        let selector = NSSelectorFromString(name + ":")
        let params = body as? [String: Any] ?? [:]
        if responds(to: selector) {
            perform(selector, with: params)
        }
    }
}

// MARK: - Bridge
@objc private extension WebViewModel {
    func newWebView(_ actions: [String: Any]) {
        guard let urlString = actions["url"] as? String,
              let url = URL(string: urlString)
        else { return }
        let style = NavigationStyle(rawValue: actions["navigationStyle"] as? String ?? "push") ?? .push
        let script = actions["afterCloseScript"] as? String
        newWebView(url, afterCloseScript: script, style: style)
    }
    
    func popWebView(_ actions: [String: Any]) {
        pop()
    }
    
    func popToRootWebView(_ actions: [String: Any]) {
        popToRootWebView()
    }
    
    func closeWebView(_ actions: [String: Any]) {
        closeWebView()
    }
    
    func firebaseLogScreen(_ actions: [String: Any]) {
        guard let screenName = actions["screenName"] as? String else { return }
        TSAnalytics.screenEvent(screenName, screenClass: self)
    }
    
    func firebaseLogEvent(_ actions: [String: Any]) {
        guard let eventName = actions["eventName"] as? String else { return }
        let parameters = actions["param"] as? [String: Any]
        TSAnalytics.logEvent(eventName, parameters: parameters)
    }
    
    func firebaseSetUserProperty(_ actions: [String: Any]) {
        guard let name = actions["name"] as? String,
              let value = actions["value"] as? String
        else { return }
        TSAnalytics.setUserProperty(value, forName: name)
    }
    
    func revealSettings(_ actions: [String: Any]) {
        revealSettings()
    }
}

#if DEBUG
struct _WebViewModelInternalState {
    var afterCloseScript: String?
}

extension WebViewModel {
    func _test_internalState() -> _WebViewModelInternalState {
        return .init(afterCloseScript: "")
    }
}
#endif

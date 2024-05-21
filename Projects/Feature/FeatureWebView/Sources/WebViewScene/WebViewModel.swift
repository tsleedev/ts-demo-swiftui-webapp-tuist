//
//  WebViewModel.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSAnalytics
import TSLocation
import TSLogger
import TSUtility
import TSWebView
import FeatureCommon
import SwiftUI
import Combine

final class WebViewModel: NSObject, ObservableObject {
    // MARK: - Published
    @Published var mainWebView: TSWebView
    @Published var childWebViews: [TSWebView] = []
    @Published var offsets: [CGFloat] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Properties
    private let coordinator: CoordinatorProtocol
    private var locationCancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    init(coordinator: CoordinatorProtocol, url: URL) {
        self.coordinator = coordinator
        let webView = TSWebView()
        webView.addScriptMessageHandler(names: ScripMessageHandlerNames.allNames)
        webView.load(url: url)
        mainWebView = webView
        super.init()
        
        webView.interactionDelegate = self
    }
    
    deinit {
        TSLogger.debug(self)
    }
}

// MARK: - Helper
private extension WebViewModel {
    func addWebView(webView: TSWebView, position: CGFloat = 0) {
        childWebViews.append(webView)
        offsets.append(position)
    }
    
    func removeWebViewState(af index: Int) {
        guard childWebViews[safe: index] != nil, offsets[safe: index] != nil else {
            print("Attempted to access out of range index: \(index)")
            return
        }
        childWebViews.remove(at: index)
        offsets.remove(at: index)
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
    
    func popWebView(_ webView: TSWebView) {
        guard !childWebViews.isEmpty,
              let index = childWebViews.firstIndex(where: { $0 == webView })
        else { return }
        
        if index < childWebViews.endIndex - 1 { // 마지막 웹뷰가 아니면 웹뷰만 제거
            removeWebViewState(af: index)
        } else { // 마지막 웹뷰인 경우 애니메이션과 함께 제거
            let duration = animationDuration(currentOffset: 0, appearing: false)
            dismissView(for: index, duration: duration)
        }
    }
    
    func pop() {
        // 배열에 최소 두 개의 요소가 있을 경우에만 마지막 웹뷰 제거
        guard !childWebViews.isEmpty else { return }
        let duration = animationDuration(currentOffset: 0, appearing: false)
        dismissView(for: childWebViews.endIndex - 1, duration: duration)
    }
    
    func popToRootWebView() {
        guard !childWebViews.isEmpty else { return }
        
        // 마지막 웹뷰 제외하고 모든 웹뷰 제거
        childWebViews.removeSubrange(1..<childWebViews.count - 1)
        offsets.removeSubrange(1..<offsets.count - 1)
        
        // 마지막 웹뷰에 대한 애니메이션 처리
        if let lastWebViewIndex = childWebViews.indices.last {
            let duration = animationDuration(currentOffset: 0, appearing: false)
            dismissView(for: lastWebViewIndex, duration: duration)
        }
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
        guard !childWebViews.isEmpty else { return false }
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
    func didReceiveMessage(webView: TSWebView, name: String, body: Any) {
        let selector = NSSelectorFromString(name + ":with:")
        let params = body as? [String: Any] ?? [:]
        if responds(to: selector) {
            perform(selector, with: webView, with: params)
        }
    }
}

// MARK: - Bridge
@objc private extension WebViewModel {
    func firebaseLogScreen(_ webView: TSWebView, with actions: [String: Any]) {
        guard let screenName = actions["screenName"] as? String else { return }
        TSAnalytics.screenEvent(screenName, screenClass: self)
    }
    
    func firebaseLogEvent(_ webView: TSWebView, withParams actions: [String: Any]) {
        guard let eventName = actions["eventName"] as? String else { return }
        let parameters = actions["param"] as? [String: Any]
        TSAnalytics.logEvent(eventName, parameters: parameters)
    }
    
    func firebaseSetUserProperty(_ webView: TSWebView, with actions: [String: Any]) {
        guard let name = actions["name"] as? String,
              let value = actions["value"] as? String
        else { return }
        TSAnalytics.setUserProperty(value, forName: name)
    }
    
    func getPermissionLocation(_ webView: TSWebView, with actions: [String: Any]) {
        guard let callback = actions["callbackId"] as? String else { return }
        let permission = TSLocationService.shared.getPermission()
        let script = "\(callback)('\(permission)');"
        webView.evaluateJavaScript(script, completion: nil)
    }
    
    func getLocation(_ webView: TSWebView, with actions: [String: Any]) {
        guard let callback = actions["callbackId"] as? String else { return }
        let location = TSLocationService.shared.getLocation()
        let response: [String: Any] = [
            "latitude": location?.latitude ?? "",
            "longitude": location?.longitude ?? ""
        ]
        
        // JavaScript로 응답 전달
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []), let jsonString = String(data: jsonData, encoding: .utf8) {
            let script = "\(callback)(\(jsonString));"
            webView.evaluateJavaScript(script, completion: nil)
        } else {
            let script = "\(callback)('');"
            webView.evaluateJavaScript(script, completion: nil)
        }
    }
    
    func setDestination(_ webView: TSWebView, with actions: [String: Any]) {
        guard let callback = actions["callbackId"] as? String else { return }
        guard let latitude = actions["latitude"] as? Double,
              let longitude = actions["longitude"] as? Double
        else {
            let script = "\(callback)(\(false));"
            webView.evaluateJavaScript(script, completion: nil)
            return
        }
        TSLocationService.shared.setDestination(latitude: latitude, longitude: longitude)
        let script = "\(callback)(\(true));"
        webView.evaluateJavaScript(script, completion: nil)
    }
    
    func removeDestination(_ webView: TSWebView, with actions: [String: Any]) {
        TSLocationService.shared.removeDestination()
        guard let callback = actions["callbackId"] as? String else { return }
        let script = "\(callback)('');"
        webView.evaluateJavaScript(script, completion: nil)
    }
    
    func startUpdatingLocation(_ webView: TSWebView, with actions: [String: Any]) {
        // 기존 구독을 취소하고 초기화
        locationCancellables.forEach { $0.cancel() }
        locationCancellables.removeAll()
        
        guard let callback = actions["callbackId"] as? String else { return }
        TSLocationService.shared.startUpdatingLocation()
        TSLocationService.shared.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { location, isAtDestination in
                let response: [String: Any] = [
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "isAtDestination": isAtDestination
                ]
                // JavaScript로 응답 전달
                if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []), let jsonString = String(data: jsonData, encoding: .utf8) {
                    let script = "\(callback)(\(jsonString));"
                    webView.evaluateJavaScript(script, completion: nil)
                } else {
                    let script = "\(callback)('');"
                    webView.evaluateJavaScript(script, completion: nil)
                }
            }
            .store(in: &locationCancellables)
    }
    
    func stopUpdatingLocation(_ webView: TSWebView, with actions: [String: Any]) {
        // 기존 구독을 취소하고 초기화
        locationCancellables.forEach { $0.cancel() }
        locationCancellables.removeAll()
        TSLocationService.shared.stopUpdatingLocation()
        
        guard let callback = actions["callbackId"] as? String else { return }
        let script = "\(callback)();"
        webView.evaluateJavaScript(script, completion: nil)
    }
    
    func revealSettings(_ actions: [String: Any]) {
        revealSettings()
    }
}

//
//  JavaScriptHandler.swift
//  TSWebViewDemo
//
//  Created by TAE SU LEE on 8/1/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSServiceAnalytics
import TSServiceLocation
import TSUIWebView
import FeatureCommon
import UIKit
import Combine

// MARK: - JavaScriptHandler
class JavaScriptHandler<Coordinator: CoordinatorProtocol>: NSObject, JavaScriptInterface {
    private var coordinator: Coordinator
    private weak var webView: TSWebView?
    
    private var locationCancellables = Set<AnyCancellable>()
    
    init(coordinator: Coordinator, webView: TSWebView) {
        self.coordinator = coordinator
        self.webView = webView
    }
    
    func screenEvent(_ response: Any) {
        guard let dictionary = response as? [String: Any],
              let name = dictionary["name"] as? String
        else { return }
        let parameters = dictionary["parameters"] as? [String: Any]
        
        var message = "name = \(name)"
        if let parameters = parameters {
            message += ", parameters = \(parameters)"
        }
        
        showAlert(title: "screenEvent", message: message)
//        Analytics.screenEvent(name, parameters: parameters)
    }
    
    func logEvent(_ response: Any) {
        guard let dictionary = response as? [String: Any],
              let name = dictionary["name"] as? String
        else { return }
        let parameters = dictionary["parameters"] as? [String: Any]
        
        var message = "name = \(name)"
        if let parameters = parameters {
            message += ", parameters = \(parameters)"
        }
        
        showAlert(title: "logEvent", message: message)
//        Analytics.logEvent(name, parameters: parameters)
    }
    
    func setUserProperty(_ response: Any) {
        guard
            let dictionary = response as? [String: Any],
            let name = dictionary["name"] as? String,
            let value = dictionary["value"] as? String
        else { return }
        let message = "name = \(name), value = \(value)"
        showAlert(title: "setUserProperty", message: message)
//        Analytics.setUserProperty(value, forName: name)
    }
    
    func getPermissionLocation(_ response: Any) {
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        let permission = TSLocationService.shared.getPermission()
        let script = "\(callback)('\(permission)');"
        webView?.evaluateJavaScript(script, completion: nil)
    }
    
    func getLocation(_ response: Any) {
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        let location = TSLocationService.shared.getLocation()
        let response: [String: Any] = [
            "latitude": location?.latitude ?? "",
            "longitude": location?.longitude ?? ""
        ]
        
        // JavaScript로 응답 전달
        if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []), let jsonString = String(data: jsonData, encoding: .utf8) {
            let script = "\(callback)(\(jsonString));"
            webView?.evaluateJavaScript(script, completion: nil)
        } else {
            let script = "\(callback)('');"
            webView?.evaluateJavaScript(script, completion: nil)
        }
    }
    
    func setDestination(_ response: Any) {
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        guard let latitude = dictionary["latitude"] as? Double,
              let longitude = dictionary["longitude"] as? Double
        else {
            let script = "\(callback)(\(false));"
            webView?.evaluateJavaScript(script, completion: nil)
            return
        }
        TSLocationService.shared.setDestination(latitude: latitude, longitude: longitude)
        let script = "\(callback)(\(true));"
        webView?.evaluateJavaScript(script, completion: nil)
    }
    
    func removeDestination(_ response: Any) {
        TSLocationService.shared.removeDestination()
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        let script = "\(callback)('');"
        webView?.evaluateJavaScript(script, completion: nil)
    }
    
    func startUpdatingLocation(_ response: Any) {
        // 기존 구독을 취소하고 초기화
        locationCancellables.forEach { $0.cancel() }
        locationCancellables.removeAll()
        
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        TSLocationService.shared.startUpdatingLocation()
        TSLocationService.shared.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location, isAtDestination in
                guard let self = self else { return }
                let response: [String: Any] = [
                    "latitude": location.coordinate.latitude,
                    "longitude": location.coordinate.longitude,
                    "isAtDestination": isAtDestination
                ]
                // JavaScript로 응답 전달
                if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []), let jsonString = String(data: jsonData, encoding: .utf8) {
                    let script = "\(callback)(\(jsonString));"
                    self.webView?.evaluateJavaScript(script, completion: nil)
                } else {
                    let script = "\(callback)('');"
                    self.webView?.evaluateJavaScript(script, completion: nil)
                }
            }
            .store(in: &locationCancellables)
    }
    
    func stopUpdatingLocation(_ response: Any) {
        // 기존 구독을 취소하고 초기화
        locationCancellables.forEach { $0.cancel() }
        locationCancellables.removeAll()
        TSLocationService.shared.stopUpdatingLocation()
        
        guard let dictionary = response as? [String: Any],
              let callback = dictionary["callbackId"] as? String
        else { return }
        let script = "\(callback)();"
        webView?.evaluateJavaScript(script, completion: nil)
    }
    
    func revealSettings(_ response: Any) {
        
    }
    
    func openPhoneSettings(_ response: Any) {
        guard let dictionary = response as? [String: Any] else { return }
        guard let setting = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(setting)
                
        guard let callback = dictionary["callbackId"] as? String else { return }
        let script = "\(callback)();"
        webView?.evaluateJavaScript(script, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
//        guard let viewController = viewController else { return }
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let confirmAction = UIAlertAction(title: "Confirm", style: .default)
//        alert.addAction(confirmAction)
//        viewController.present(alert, animated: true, completion: nil)
        let state = AlertPanelState(title: title, message: message)
        coordinator.alert(state)
    }
}

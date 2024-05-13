//
//  CoordinatorProtocol.swift
//  FeatureCommon
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation
import TSWebView

// 네비게이션 상태를 나타내는 열거형
public enum AppRoute: Hashable, Identifiable {
    public var id: String {
        String(describing: self)
    }
    
    case webview(WebState)
    case settings
}

public struct WebState: Hashable {
    public let id: UUID
    public let url: URL
    public let afterCloseScript: String?
    public let completion: (() -> Void)?
    
    public init(id: UUID = UUID(), url: URL, afterCloseScript: String?, completion: (() -> Void)? = nil) {
        self.id = id
        self.url = url
        self.afterCloseScript = afterCloseScript
        self.completion = completion
    }
    
    public static func == (lhs: WebState, rhs: WebState) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct AlertPanelState {
    public let message: String
    public let completion: (() -> Void)?
    
    public init(message: String, completion: (() -> Void)? = nil) {
        self.message = message
        self.completion = completion
    }
}

public struct ConfirmPanelState {
    public let message: String
    public let completion: (Bool) -> Void
    
    public init(message: String, completion: @escaping (Bool) -> Void) {
        self.message = message
        self.completion = completion
    }
}

public protocol CoordinatorProtocol {
    func deepLink(_ route: AppRoute)
    func push(_ route: AppRoute)
    func replace(_ route: AppRoute)
    func pop()
    func dismiss()
    func popToRoot()
    func fullScreenCover(_ route: AppRoute)
    func alert(_ state: AlertPanelState)
    func confirm(_ state: ConfirmPanelState)
}

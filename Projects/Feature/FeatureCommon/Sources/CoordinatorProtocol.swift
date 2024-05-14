//
//  CoordinatorProtocol.swift
//  FeatureCommon
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import TSWebView

// 네비게이션 상태를 나타내는 열거형
public enum AppRoute: Hashable {
    case webWiew(URL)
    case settings
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
    func pop()
    func dismiss()
    func popToRoot()
    func fullScreenCover(_ route: AppRoute)
    func alert(_ state: AlertPanelState)
    func confirm(_ state: ConfirmPanelState)
}

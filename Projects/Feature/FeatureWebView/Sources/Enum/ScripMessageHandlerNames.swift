//
//  ScripMessageHandlerNames.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

enum ScripMessageHandlerNames: String, CaseIterable {
    case screenEvent
    case logEvent
    case setUserProperty
    case getPermissionLocation
    case getLocation
    case setDestination
    case removeDestination
    case startUpdatingLocation
    case stopUpdatingLocation
    case revealSettings
    case openPhoneSettings
}

extension ScripMessageHandlerNames {
    static var allNames: [String] {
        return allCases.map { $0.rawValue }
    }
}

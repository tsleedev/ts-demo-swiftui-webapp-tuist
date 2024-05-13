//
//  ScripMessageHandlerNames.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

enum ScripMessageHandlerNames: String, CaseIterable {
    case firebaseLogScreen
    case firebaseLogEvent
    case firebaseSetUserProperty
    case revealSettings
}

extension ScripMessageHandlerNames {
    static var allNames: [String] {
        return allCases.map { $0.rawValue }
    }
}

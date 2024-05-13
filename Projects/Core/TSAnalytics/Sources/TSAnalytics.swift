//
//  TSAnalytics.swift
//  TSAnalytics
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import FirebaseBridge
import Foundation


public struct TSAnalytics {
    public static func screenEvent(_ screenName: String, screenClass: Any) {
        FBAnalytics.screenEvent(screenName, screenClass: String(describing: type(of: screenClass)))
    }
    
    public static func screenEvent(_ screenName: String, screenClass: String) {
        FBAnalytics.screenEvent(screenName, screenClass: screenClass)
    }
    
    public static func logEvent(_ name: String, parameters: [String: Any]?) {
        FBAnalytics.logEvent(name, parameters: parameters)
    }
    
    public static func setUserProperty(_ value: String?, forName: String) {
        FBAnalytics.setUserProperty(value, forName: forName)
    }
}

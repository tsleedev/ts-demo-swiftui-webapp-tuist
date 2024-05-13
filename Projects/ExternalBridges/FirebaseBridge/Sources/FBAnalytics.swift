//
//  FBAnalytics.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation
import FirebaseAnalytics

public struct FBAnalytics {
    public static func setUserID(_ userID: String?) {
        Analytics.setUserID(userID)
    }
    
    public static func screenEvent(_ screenName: String, screenClass: String) {
        let parameters = [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenClass
        ]
        logEvent(AnalyticsEventScreenView, parameters: parameters)
    }
    
    public static func logEvent(_ name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    public static func setUserProperty(_ value: String?, forName: String) {
        Analytics.setUserProperty(value, forName: forName)
    }
}

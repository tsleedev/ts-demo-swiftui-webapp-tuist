//
//  FBCrashlytics.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

public struct FBCrashlytics {
    public static func crashytics(log: String) {
        Crashlytics.crashlytics().log(log)
    }
}

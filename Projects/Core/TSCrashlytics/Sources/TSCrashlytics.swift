//
//  TSCrashlytics.swift
//  TSCrashlytics
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import FirebaseBridge
import Foundation

public enum ReportType: Int, RawRepresentable {
    case app, web, api
    func toString() -> String {
        switch self {
        case .app: return "APP"
        case .web: return "WEB"
        case .api: return "api"
        }
    }
}


public struct TSCrashlytics {
    public static func crashlyticsLog(type: ReportType, log: String) {
        let sendLog = "\(type.toString()) : \(log)"
        FBCrashlytics.crashytics(log: sendLog)
    }
}

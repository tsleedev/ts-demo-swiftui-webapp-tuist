//
//  UserAgentManager.swift
//  TSUtility
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import WebKit

public struct UserAgentManager {
    public static func fetchUserAgent() async throws -> String {
        return try await WKWebView().fetchUserAgent()
    }
}

private extension WKWebView {
    func fetchUserAgent() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.evaluateJavaScript("navigator.userAgent") { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let userAgent = result as? String {
                    continuation.resume(returning: userAgent)
                } else {
                    let error = NSError(domain: "UserAgentError", code: 0, userInfo: nil)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

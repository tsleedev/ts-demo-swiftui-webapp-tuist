//
//  TSDeepLinkManager.swift
//  TSDeepLinks
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public class FQDeepLinkeManager {
    public static let shared = FQDeepLinkeManager()
    private init() {}
    
    public private(set) var deepLink: URL?
    
    public func setDeepLink(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }
        self.setDeepLink(url)
    }
    
    public func setDeepLink(_ url: URL) {
        self.deepLink = url
    }
    
    public func clearDeepLink() {
        self.deepLink = nil
    }
}

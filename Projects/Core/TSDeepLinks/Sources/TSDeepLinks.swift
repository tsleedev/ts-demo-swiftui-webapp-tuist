//
//  TSDeepLinks.swift
//  TSDeepLinks
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import FirebaseBridge
import Foundation

public struct TSDeepLinks {
    private let dynamicLinksHandler: DynamicLinksHandling
    
    public init(dynamicLinksHandler: DynamicLinksHandling = FBDynamicLinks()) {
        self.dynamicLinksHandler = dynamicLinksHandler
    }
    
    public func handleUniversalLink(_ url: URL) -> Bool {
        dynamicLinksHandler.handleUniversalLink(url) { result in
            switch result {
            case .success(let success):
                FQDeepLinkeManager.shared.setDeepLink(success)
            case .failure(let failure):
                break
            }
        }
    }
    
    public func handleUniversalLink(_ url: URL) async -> URL {
        await withCheckedContinuation { continuation in
            dynamicLinksHandler.handleUniversalLink(url) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let failure):
                    break
                }
            }
        }
    }
}

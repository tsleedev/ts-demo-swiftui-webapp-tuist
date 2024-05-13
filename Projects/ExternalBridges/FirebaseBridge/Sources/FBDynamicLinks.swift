//
//  FBDynamicLinks.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import FirebaseDynamicLinks

public struct FBDynamicLinks: DynamicLinksHandling {
    public init() {}
    
    public func handleUniversalLink(_ url: URL, completion: @escaping (Result<URL, any Error>) -> Void) -> Bool {
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
            if let error = error {
                completion(.failure(error))
            } else if let dynamicLink = dynamicLink, let linkURL = dynamicLink.url {
                completion(.success(linkURL))
            } else {
                // 여기서는 어떤 오류도 없지만 URL도 없는 경우
                let error = NSError(
                    domain: "FBDynamicLinksError",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Inavlid dynamic link"]
                )
                completion(.failure(error))
            }
        }
    }
}

//
//  MockDynamicLinksHandler.swift
//  TSDeepLinks
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

#if DEBUG
import FirebaseBridge
import Foundation

class MockDynamicLinksHandler: DynamicLinksHandling {
    var mockResult: Result<URL, Error>?
    
    func handleUniversalLink(_ url: URL, completion: @escaping (Result<URL, any Error>) -> Void) -> Bool {
        if let mockResult = mockResult {
            completion(mockResult)
            switch mockResult {
            case .success:
                return true
            case .failure:
                return false
            }
        } else {
            // 기본적으로 실패를 반환하는 경우를 시뮬레이션 할 수 있습니다.
            let error = NSError(domain: "MockError", code: 0, userInfo: nil)
            completion(.failure(error))
            return false
        }
    }
}
#endif

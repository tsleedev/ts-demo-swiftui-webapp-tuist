//
//  APIService.swift
//  Network
//
//  Created by TAE SU LEE on 2023/09/16.
//  Copyright © 2023 https://github.com/tsleedev. All rights reserved.
//

import Foundation
import Moya

public typealias SearchAPIService = APIService<SearchAPI>

public final class APIService<Target: TargetType> {
    private let provider: MoyaProvider<Target> = MoyaProvider(
        session: {
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            configuration.timeoutIntervalForRequest = 20
            configuration.timeoutIntervalForResource = 20
            return Session(configuration: configuration, startRequestsImmediately: false)
        }(),
        plugins: [APILogPlugin()]
    )
    
    public init() { }
    
    public func request(_ target: Target) async throws -> Data {
        await withCheckedContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case let .success(response):
                    if (200...299) ~= response.statusCode {
                        // 공통 에러 처리
                        continuation.resume(returning: response.data)
                    } else {
                        // custom error
                    }
                case let .failure(error):
                    print(error)
//                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

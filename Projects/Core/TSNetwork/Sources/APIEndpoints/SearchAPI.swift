//
//  SearchAPI.swift
//  Network
//
//  Created by TAE SU LEE on 2023/09/16.
//  Copyright © 2023 https://github.com/tsleedev. All rights reserved.
//

import Foundation
import Moya

public enum SearchAPI {
    case readItems(String)
}

extension SearchAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://itunes.apple.com")!
    }
    
    public var path: String {
        switch self {
        case .readItems:
            return "/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .readItems:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Moya.Task {
        switch self {
        case .readItems(let query):
            return .requestParameters(parameters: ["term": query, "country": "kr", "entity": "software"], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .readItems:
            return nil
        }
    }
}

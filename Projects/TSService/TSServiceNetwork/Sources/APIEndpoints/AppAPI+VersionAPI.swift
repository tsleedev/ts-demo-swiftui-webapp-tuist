//
//  AppAPI+VersionAPI.swift
//  TSServiceNetwork
//
//  Created by TAE SU LEE on 9/2/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import Moya

extension AppAPI {
    public enum VersionAPI {
        case getVersion
        case test
    }
}

extension AppAPI.VersionAPI: TargetType {
    public var baseURL: URL {
        return AppAPI.version(self).baseURL
    }
    
    public var path: String {
        switch self {
        case .getVersion:
            return "/version"
        case .test:
            return "/search"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getVersion:
            return .get
        case .test:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getVersion:
            return .requestPlain
        case .test:
            return .requestParameters(parameters: ["term": "", "country": "kr", "entity": "software"], encoding: URLEncoding.default)
        }
    }
}

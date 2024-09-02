//
//  CommonTargetType.swift
//  TSServiceNetwork
//
//  Created by TAE SU LEE on 9/2/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import Moya

public protocol CommonTargetType: TargetType {}

extension CommonTargetType {
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

extension AppAPI.VersionAPI: CommonTargetType {}

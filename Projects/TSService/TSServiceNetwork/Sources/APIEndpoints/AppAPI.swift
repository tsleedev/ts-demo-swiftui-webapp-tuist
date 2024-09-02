//
//  AppAPI.swift
//  TSServiceNetwork
//
//  Created by TAE SU LEE on 9/2/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSCoreConfiguration
import Foundation

public typealias AppVersionAPIService = APIService<AppAPI.VersionAPI>

public enum AppAPI {
    case version(VersionAPI)
    
    public var baseURL: URL {
//        return AppConfiguration.shared.apiBaseURL
        return URL(string: "https://itunes.apple.com")!
    }
}

//
//  EnvironmentConfigurationProtocol.swift
//  TSCoreConfiguration
//
//  Created by TAE SU LEE on 9/2/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public protocol EnvironmentConfigurationProtocol {
    var apiBaseURL: URL { get }
    var webBaseURL: URL { get }
}

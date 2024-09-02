//
//  AppConfiguration.swift
//  TSCoreConfiguration
//
//  Created by TAE SU LEE on 9/2/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public class AppConfiguration: EnvironmentConfigurationProtocol {
    public static let shared = AppConfiguration()
    private var currentConfiguration: EnvironmentConfigurationProtocol?
    private let queue = DispatchQueue(label: "com.tsleedev.appconfiguration", attributes: .concurrent)
    private var isConfigured: Bool {
        queue.sync { currentConfiguration != nil }
    }

    private init() {}

    public func configure(with configuration: EnvironmentConfigurationProtocol) {
        queue.sync(flags: .barrier) {
            guard currentConfiguration == nil else {
                fatalError("AppConfiguration is alreadyConfigured.")
            }
            currentConfiguration = configuration
        }
    }

    public var apiBaseURL: URL {
        getConfigValue { $0.apiBaseURL }
    }
    
    public var webBaseURL: URL {
        getConfigValue { $0.webBaseURL }
    }
    
    private func getConfigValue<T>(_ getter: (EnvironmentConfigurationProtocol) -> T) -> T {
        queue.sync {
            guard let config = currentConfiguration else {
                fatalError("AppConfiguration is not configured. Call configure(with:) first.")
            }
            return getter(config)
        }
    }
}

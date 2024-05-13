//
//  MockAppClient.swift
//  WebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct MockAppClient: AppClientProtocol {
    var versionItem: VersionItem?
    var error: Error?
    
    func version() async throws -> VersionItem {
        if let error = self.error {
            throw error
        } else if let versionItem = self.versionItem {
            return versionItem
        } else {
            return .mock
        }
    }
}

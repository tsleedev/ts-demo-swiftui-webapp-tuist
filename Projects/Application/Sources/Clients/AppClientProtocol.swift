//
//  AppClientProtocol.swift
//  WebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

protocol AppClientProtocol {
    func version() async throws -> VersionItem
}

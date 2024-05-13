//
//  VersionItem.swift
//  TSWebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import Foundation

struct VersionItem: Decodable {
    let version: String
}

#if DEBUG
extension VersionItem {
    static let mock = Self(
        version: "1.0.0"
    )
}
#endif

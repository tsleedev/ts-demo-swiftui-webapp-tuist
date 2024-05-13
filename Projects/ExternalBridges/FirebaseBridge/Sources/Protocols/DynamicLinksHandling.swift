//
//  DynamicLinksHandling.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public protocol DynamicLinksHandling {
    @discardableResult
    func handleUniversalLink(_ url: URL, completion: @escaping (Result<URL, Error>) -> Void) -> Bool
}

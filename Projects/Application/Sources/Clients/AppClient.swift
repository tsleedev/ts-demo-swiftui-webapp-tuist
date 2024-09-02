//
//  AppClient.swift
//  TSWebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSServiceNetwork
import Foundation

struct AppClient: AppClientProtocol {
    private let service = AppVersionAPIService()
    
    func version() async throws -> VersionItem {
        do {
            let data = try await service.request(.test)
            let decoder = JSONDecoder()
            let item = try decoder.decode(VersionItem.self, from: data)
            return item
        } catch {
            throw error
        }
    }
}

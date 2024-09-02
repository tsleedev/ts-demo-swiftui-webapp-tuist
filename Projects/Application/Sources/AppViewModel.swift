//
//  AppViewModel.swift
//  TSWebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import Foundation

class AppViewModel: ObservableObject {
    @Published var isInitialized = false
    @Published var isAppActive = true // 앱이 활성 상태인지 관리
    @Published var mainIsLoaded = false
    
    @Published var shouldShowAlert = false
    @Published var errorMessage: String?
    
    // MARK: - Initialize with Client
    private let appClient: AppClientProtocol
    
    init(appClient: AppClientProtocol) {
        self.appClient = appClient
    }
    
    func fetchVersion() async {
        do {
            let item = try await appClient.version()
            await MainActor.run {
                isInitialized = true
            }
            
            try await Task.sleep(for: .seconds(1)) // 1초 대기
            await MainActor.run {
                mainIsLoaded = true
            }
        } catch {
            print(error)
            await MainActor.run {
                shouldShowAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

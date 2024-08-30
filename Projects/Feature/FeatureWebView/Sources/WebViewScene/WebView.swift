//
//  WebView.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import SwiftUI

struct WebView<Coordinator: CoordinatorProtocol>: View {
    @StateObject private var coordinator: Coordinator
    private let startUrl: URL
    
    init(coordinator: Coordinator, startUrl: URL) {
        _coordinator = StateObject(wrappedValue: coordinator)
        self.startUrl = startUrl
    }
    
    var body: some View {
        ZStack {
            WebViewRepresentable(coordinator: coordinator, startUrl: startUrl)
        }
        .navigationBarBackButtonHidden()
    }
}

#if DEBUG
class MockCoordinator: CoordinatorProtocol {
    func deepLink(_ route: FeatureCommon.AppRoute) {}
    func push(_ route: FeatureCommon.AppRoute) {}
    func pop() {}
    func dismiss() {}
    func popToRoot() {}
    func fullScreenCover(_ route: FeatureCommon.AppRoute) {}
    func alert(_ state: FeatureCommon.AlertPanelState) {}
    func confirm(_ state: FeatureCommon.ConfirmPanelState) {}
}

#Preview {
    let mockCoordinator = MockCoordinator()
    let url = ViewFactory.createWebStateForLocalHtml()
    let webView = ViewFactory.createWebView(coordinator: mockCoordinator, url: url)
    return webView.environmentObject(mockCoordinator)
}
#endif

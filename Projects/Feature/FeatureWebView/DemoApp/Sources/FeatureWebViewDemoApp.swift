//
//  FeatureWebViewDemoApp.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 2024/05/14.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import FeatureWebView
import SwiftUI

@main
struct FeatureWebViewDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ViewFactory.createWebView(coordinator: MockCoordinator(), url: ViewFactory.createWebStateForLocalHtml())
        }
    }
}

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

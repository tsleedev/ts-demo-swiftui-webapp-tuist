//
//  WebView.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import SwiftUI

struct WebView: View {
    @StateObject var viewModel: WebViewModel
    
    var body: some View {
        ZStack {
            WebViewRepresentable(viewModel: viewModel, webView: viewModel.mainWebView, isSwipeBackGestureEnabled: false)
            ForEach(Array(zip(viewModel.childWebViews.indices, viewModel.childWebViews)), id: \.1.id) { index, webView in
                Color.black
                    .opacity(Double(max(0.2 - 0.2 * (abs(viewModel.offsets[index]) / 500), 0)))
                WebViewRepresentable(viewModel: viewModel, webView: webView)
                    .offset(x: viewModel.offsets[index])
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            print("tslee11 onAppear")
            viewModel.registerForAppStateNotifications()
        })
        .onDisappear(perform: {
            viewModel.unregisterForAppStateNotifications()
        })
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
    return webView
}
#endif

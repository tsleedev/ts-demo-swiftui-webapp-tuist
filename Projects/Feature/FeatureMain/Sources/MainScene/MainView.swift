//
//  MainView.swift
//  FeatureMain
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import SwiftUI

public struct MainView: View {
    @StateObject private var coordinator: AppCoordinator
    
    public init(coordinator: AppCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.buildInitial()
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.build(route: route)
                }
        }
        .fullScreenCover(
            isPresented: $coordinator.shouldFullScreen,
            onDismiss: { coordinator.handleFullScreenChange() },
            content: { coordinator.fullScreen(isActive: $coordinator.shouldFullScreen) }
        )
        .alert(
            isPresented: Binding(
                get: { coordinator.shouldShowAlert },
                set: {
                    coordinator.shouldShowAlert = $0
                    if !$0 {
                        coordinator.handleAlertChange()
                    }
                }
            ),
            content: { coordinator.showAlert() }
        )
        .onAppear(perform: {
            print("tslee MainView onAppear")
        })
    }
}

#if DEBUG
import FeatureWebView

#Preview {
    let url = ViewFactory.createWebStateForLocalHtml()
    let webState = WebState(url: url, afterCloseScript: nil)
    let coordinator = AppCoordinator(.webview(webState), isActive: .constant(false))
    return MainView(coordinator: coordinator)
}
#endif

//
//  AppCoordinator.swift
//  FeatureMain
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import FeatureWebView
import FeatureSettings
import SwiftUI
import Combine

public class AppCoordinator: ObservableObject, CoordinatorProtocol {
    // MARK: - Published
    @Published var path: NavigationPath
    private var routeStack: [AppRoute] = []
    
    // FullScreen 처리
    @Published var shouldFullScreen: Bool = false
    private var fullScreenCover: AppRoute?
    
    // Alert 처리
    @Published var shouldShowAlert: Bool = false
    private var alertPanelState: AlertPanelState?
    private var confirmPanelState: ConfirmPanelState?
    
    // MARK: - Properties
    private var initialRoute: AppRoute
    @Binding private var isActive: Bool // fullScreen 닫을 때 사용
    
    // MARK: - Initialize
    public init(_ initialRout: AppRoute, isActive: Binding<Bool>) {
        self.initialRoute = initialRout
        self.path = NavigationPath()
        routeStack.append(initialRout)
        _isActive = isActive
    }
}

// MARK: - CoordinatorProtocol
extension AppCoordinator {
    public func deepLink(_ route: AppRoute) {
        path.removeLast(path.count)
        routeStack.removeLast(path.count)
    }
    
    public func push(_ route: AppRoute) {
        path.append(route)
        routeStack.append(route)
    }
    
    public func replace(_ route: AppRoute) {
        
    }
    
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        } else if isActive { // 뒤로 갈 수 없으면 창 닫기
            isActive = false
        }
    }
    
    public func dismiss() {
        isActive = false
    }
    
    // Root 화면으로 뒤로가기
    public func popToRoot() {
        path.removeLast(path.count)
        routeStack.removeLast(path.count)
    }
    
    public func fullScreenCover(_ route: AppRoute) {
        fullScreenCover = route
        shouldFullScreen = true
    }
    
    public func alert(_ state: AlertPanelState) {
        alertPanelState = state
        shouldShowAlert = true
    }
    
    public func confirm(_ state: ConfirmPanelState) {
        confirmPanelState = state
        shouldShowAlert = true
    }
}

// MARK: - Internal
extension AppCoordinator {
    // 앱을 켤 때 처음 나타나는 뷰를 정함
    func buildInitial() -> some View {
        return build(route: initialRoute)
    }
    
    // 이동할 화면을 생성함
    @ViewBuilder
    func build(route: AppRoute) -> some View {
        switch route {
        case .webWiew(let url):
            FeatureWebView.ViewFactory.createWebView(coordinator: self, url: url)
        case .settings:
            FeatureSettings.ViewFactory.createSettingsView()
        }
    }
    
    @ViewBuilder
    func fullScreen(isActive: Binding<Bool>) -> some View {
        if let route = fullScreenCover {
            let coordinator = AppCoordinator(route, isActive: isActive)
            MainView(coordinator: coordinator)
        }
    }
    
    func handleFullScreenChange() {
        if shouldFullScreen { return }
        fullScreenCover = nil
    }
    
    func showAlert() -> Alert {
        let alert: Alert
        if let state = alertPanelState {
            alert = Alert(
                title: Text("알림"),
                message: Text(state.message),
                dismissButton: .default(Text("확인"), action: state.completion)
            )
        } else if let state = confirmPanelState {
            alert = Alert(
                title: Text("알림"),
                message: Text(state.message),
                primaryButton: .default(Text("확인"), action: { state.completion(true) }),
                secondaryButton: .cancel(Text("취소"), action: { state.completion(false) })
            )
        } else {
            alert = Alert(title: Text(""))
        }
        return alert
    }
    
    func handleAlertChange() {
        if shouldShowAlert { return }
        alertPanelState = nil
        confirmPanelState = nil
    }
}

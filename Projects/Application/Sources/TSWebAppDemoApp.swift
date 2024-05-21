//
//  TSWebAppDemoApp.swift
//  TSWebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSCrashlytics
import TSDeepLinks
import TSMessaging
import TSUtility
import TSWebView
import FirebaseBridge
import FeatureCommon
import FeatureMain
import FeatureWebView
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FBAppConfig.configure()
        TSCrashlytics.crashlyticsLog(type: .app, log: "application(_:didFinishLaunchingWithOptions:")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        
    }
}

@main
struct TSWebAppDemoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject private var viewModel: AppViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init() {
        FBAppConfig.configure()
        TSCrashlytics.crashlyticsLog(type: .app, log: "TSWebAppDemoApp_init")
        TSWebView.applictionNameForUserAgent = "TSWebAppDemo/\(AppInfo.version)"
        
        self.viewModel = AppViewModel(appClient: MockAppClient())
        let url = ViewFactory.createWebStateForLocalHtml()
        self.coordinator = AppCoordinator(.webWiew(url), isActive: .constant(false))
        requestAuthNotification()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if viewModel.isInitialized {
                    FeatureMain.MainView(coordinator: coordinator)
                }
                if !(viewModel.isInitialized && viewModel.isAppActive) {
                    SplashView()
                }
                if viewModel.shouldShowAlert {
                    Color.clear
                        .alert(
                            isPresented: Binding(
                                get: { viewModel.shouldShowAlert },
                                set: {
                                    viewModel.shouldShowAlert = $0
                                    if !$0 {
                                        viewModel.errorMessage = nil
                                    }
                                }
                            ),
                            content: { showAlert() }
                        )
                }
            }
            .onOpenURL(perform: { url in
                Task {
                    let deepLink = await TSDeepLinks().handleUniversalLink(url)
//                    coordinator.deepLink(.webView(.init(url: deepLink, afterCloseScript: nil)))
                }
            })
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: { userActivity in
                Task {
                    guard let url = userActivity.webpageURL else { return }
                    let deepLink = await TSDeepLinks().handleUniversalLink(url)
//                    coordinator.deepLink(.webView(.init(url: deepLink, afterCloseScript: nil)))
                }
            })
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .active:
                    viewModel.isAppActive = true
                    if !viewModel.isInitialized {
                        Task {
                            await viewModel.fetchVersion()
                        }
                    }
                case .background, .inactive:
                    viewModel.isAppActive = false
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func requestAuthNotification() {
        let center = UNUserNotificationCenter.current()
        let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        center.requestAuthorization(options: notificationAuthOptions) { success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Views
extension TSWebAppDemoApp {
    func showAlert() -> Alert {
        let alert = Alert(
            title: Text("알림"),
            message: Text(viewModel.errorMessage ?? ""),
            dismissButton: .default(Text("확인"))
        )
        return alert
    }
}

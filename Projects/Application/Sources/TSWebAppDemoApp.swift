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
        application.registerForRemoteNotifications()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let content = UNMutableNotificationContent()
        content.title = "앱 종료"
        content.body = "앱이 종료되었습니다."
        
        let uuidString = UUID().uuidString
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Test-\(uuidString)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Handle the error
            }
        })
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰을 문자열로 변환
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let deviceTokenString = tokenParts.joined()
        
        // 디바이스 토큰 출력 (디버깅용)
        print("Device Token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        
    }
}

@main
struct TSWebAppDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject private var viewModel: AppViewModel
    @ObservedObject private var coordinator: AppCoordinator
    
    init() {
        FBAppConfig.configure()
        TSCrashlytics.crashlyticsLog(type: .app, log: "TSWebAppDemoApp_init")
        TSWebView.applictionNameForUserAgent = "TSWebAppDemo/\(AppInfo.version)"
        
        self.viewModel = AppViewModel(appClient: MockAppClient())
        let url = ViewFactory.createWebStateForLocalHtml()
        self.coordinator = AppCoordinator(.webView(url), isActive: .constant(false))
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
                    coordinator.deepLink(.webView(deepLink))
                }
            })
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: { userActivity in
                Task {
                    guard let url = userActivity.webpageURL else { return }
                    let deepLink = await TSDeepLinks().handleUniversalLink(url)
                    coordinator.deepLink(.webView(deepLink))
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

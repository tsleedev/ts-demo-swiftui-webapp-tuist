//
//  FeatureMapDemoApp.swift
//  FeatureMap
//
//  Created by taesulee on 2024/05/14.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSLogger
import FeatureCommon
import FeatureMap
import SwiftUI
import UIKit
import CoreLocation
import BackgroundTasks

//class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
//
//    var window: UIWindow?
//    let locationManager = CLLocationManager()
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        TSLogger.debug("========= AppStart =========")
//        
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
////        locationManager.startUpdatingLocation() // 실시간 위치 업데이트
//        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourcompany.app.refresh", using: nil) { task in
//            self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
//        
//        return true
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        TSLogger.debug("")
//        scheduleAppRefresh()
//    }
//     
//    func applicationWillTerminate(_ application: UIApplication) {
//        TSLogger.debug("")
//        scheduleAppRefresh()
//    }
//    
//    func scheduleAppRefresh() {
//        TSLogger.debug("")
//        let request = BGAppRefreshTaskRequest(identifier: "com.yourcompany.app.refresh")
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 5) // 5초 후 실행
//        
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            TSLogger.error("Could not schedule app refresh: \(error)")
//        }
//    }
//    
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        TSLogger.debug("")
//        scheduleAppRefresh()
//        
//        task.expirationHandler = {
//            // 작업이 너무 오래 걸리면 작업을 취소합니다.
//            task.setTaskCompleted(success: false)
//        }
//        
//        // 위치 업데이트 요청
//        locationManager.requestLocation()
//        
//        // 작업 완료 후 호출합니다.
//        task.setTaskCompleted(success: true)
//    }
//    
////    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        switch status {
////        case .authorizedAlways, .authorizedWhenInUse:
////            locationManager.startUpdatingLocation()
////        case .denied, .restricted:
////            TSLogger.debug("Location services are not authorized")
////        case .notDetermined:
////            locationManager.requestAlwaysAuthorization()
////        @unknown default:
////            fatalError()
////        }
////    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let logMessage = "Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)"
//        TSLogger.debug(logMessage)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        let logMessage = "Failed to get location: \(error)"
//        TSLogger.debug(logMessage)
//    }
//}


class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private var targetLocation: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 37.43435176451452, longitude: 126.90276015091996) // 석수역1호선 1번출구

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TSLogger.debug("========= AppStart =========")
        
        requestAuthNotification()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50 // 50미터 간격으로 위치 업데이트
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 위치 업데이트 허용
        locationManager.pausesLocationUpdatesAutomatically = false // 자동 일시 중지 비활성화
        
        // 중요 위치 변경 이벤트로 앱이 시작된 경우 처리
        if let _ = launchOptions?[.location] {
            // 위치 업데이트 처리
            TSLogger.debug("App launched due to significant location change")
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        TSLogger.debug("========= applicationWillTerminate =========")
    }
    
    func requestAuthNotification() {
        let center = UNUserNotificationCenter.current()
        let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        center.requestAuthorization(options: notificationAuthOptions) { success, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            TSLogger.debug("Location services are notDetermined.")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // 앱 사용 중 권한이 승인되면 백그라운드 권한 요청
            TSLogger.debug("Location services are authorizedWhenInUse.")
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            TSLogger.debug("Location services are authorizedAlways.")
            locationManager.startMonitoringSignificantLocationChanges()
        case .restricted:
            TSLogger.debug("Location services are restricted.")
        case .denied:
            TSLogger.debug("Location services are denied.")
        @unknown default:
            TSLogger.debug("Location services are unknown default.")
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        TSLogger.debug(location)
        // 특정 위치에 도달했는지 확인
        if let target = targetLocation {
            let targetLocation = CLLocation(latitude: target.latitude, longitude: target.longitude)
            if location.distance(from: targetLocation) < 100 { // 예: 100미터 이내
                locationManager.stopMonitoringSignificantLocationChanges()
                TSLogger.debug("Target location reached. Monitoring stopped.")
                let content = UNMutableNotificationContent()
                content.title = "알림"
                content.body = "약속 장소에 도착했어요."
                
                let uuidString = UUID().uuidString
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "Test-\(uuidString)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        // Handle the error
                    }
                })
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let logMessage = "Failed to get location: \(error)"
        TSLogger.debug(logMessage)
    }
}

@main
struct FeatureMapDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#if DEBUG
    @State private var showLoggerView = false
#endif
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ViewFactory.createMapView()
                
#if DEBUG
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showLoggerView.toggle()
                        }) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding()
                    }
                }
                .sheet(isPresented: $showLoggerView) {
                    LoggerView()
                }
#endif
            }
        }
        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .background {
                TSLogger.debug(newPhase)
//                appDelegate.scheduleAppRefresh()
//            }
        }
    }
}

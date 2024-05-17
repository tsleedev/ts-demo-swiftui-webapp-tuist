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

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TSLogger.debug("========= AppStart =========")
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            TSLogger.debug("authorizedAlways")
            locationManager.startMonitoringSignificantLocationChanges()
        case .authorizedWhenInUse:
            TSLogger.debug("authorizedWhenInUse")
            locationManager.startMonitoringSignificantLocationChanges()
        case .denied:
            TSLogger.debug("denied")
        case .restricted:
            TSLogger.debug("restricted")
        case .notDetermined:
            TSLogger.debug("notDetermined")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            TSLogger.debug("@unknown default")
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let logMessage = "Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)"
        TSLogger.debug(logMessage)
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
            if newPhase == .background {
                TSLogger.debug("background")
//                appDelegate.scheduleAppRefresh()
            }
        }
    }
}

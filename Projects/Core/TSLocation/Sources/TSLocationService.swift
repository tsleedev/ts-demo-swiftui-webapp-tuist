//
//  TSLocationService.swift
//  TSLocation
//
//  Created by taesulee on 2024/05/14.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSLogger
import Foundation
import CoreLocation
import Combine

public final class TSLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    public let locationPublisher = PassthroughSubject<CLLocation, Never>()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 위치 업데이트 허용
        locationManager.pausesLocationUpdatesAutomatically = false // 자동 일시 중지 비활성화
        locationManager.showsBackgroundLocationIndicator = true
    }
}

public extension TSLocationService {
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        let location = CLLocationCoordinate2D(latitude: 37.4967867, longitude: 126.9978993)
        let region = CLCircularRegion(center: location,
                                              radius: 1.0,
                                              identifier: "id")
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        locationManager.startUpdatingLocation()
//        locationManager.startMonitoring(for: region)
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

private extension TSLocationService {
    func getLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        print("\(coordinate)")
    }
}

extension TSLocationService {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        print("\(#function) \(location)")
//        TSLogger.debug(location)
        locationPublisher.send(location)
        fireNotification(body: "\(location)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get location: \(error)")
//        TSLogger.error(error)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print("locationManagerDidChangeAuthorization \(manager)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            fireNotification("Inside", body: "들어왔습니다.")
            print("inside")
        case .outside:
            fireNotification("Outside", body: "나왔습니다.")
            print("outside")
        case .unknown:
            print("unknown")
            break
        }
    }
}

// MARK: - Test
import UserNotifications

private extension TSLocationService {
    func fireNotification(_ title: String = "Background Test", body: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
//            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                
                let uuidString = UUID().uuidString
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "Test-\(uuidString)", content: content, trigger: trigger)
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        // Handle the error
                    }
                })
            }
//        }
    }
}

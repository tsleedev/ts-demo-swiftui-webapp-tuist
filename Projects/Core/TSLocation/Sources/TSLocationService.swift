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
    public static let shared = TSLocationService()
    private let locationManager = CLLocationManager()
    private var destinationRegion: CLCircularRegion?
    public let locationPublisher = PassthroughSubject<(location: CLLocation, isAtDestination: Bool), Never>()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50 // 50미터 간격으로 위치 업데이트
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 위치 업데이트 허용
        locationManager.pausesLocationUpdatesAutomatically = false // 자동 일시 중지 비활성화
    }
}

// MARK: - Public
public extension TSLocationService {
    func setDestination(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: location,
                                      radius: 1.0,
                                      identifier: "id")
        destinationRegion = region
    }
    
    func removeDestination() {
        destinationRegion = nil
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        if let destinationRegion = destinationRegion {
            locationManager.startMonitoring(for: destinationRegion)
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getPermission() -> String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "notDetermined"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .authorizedAlways:
            return "authorizedAlways"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        @unknown default:
            return "unknown default"
        }
    }
    
    func getLocation() -> (latitude: String, longitude: String)? {
        guard let coordinate = locationManager.location?.coordinate else { return nil }
        return (String(coordinate.latitude), String(coordinate.longitude))
    }
}

// MARK: - CLLocationManagerDelegate
extension TSLocationService {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("\(#function) \(location)")
//        TSLogger.debug(location)
        locationPublisher.send((location, false))
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
            fireNotification("알림", body: "목적지에 도착했습니다.")
            stopUpdatingLocation()
            if let location = locationManager.location {
                locationPublisher.send((location, true))
            }
            print("inside")
        case .outside:
            print("outside")
        case .unknown:
            print("unknown")
        }
    }
}

// MARK: - Test
import UserNotifications

private extension TSLocationService {
    func fireNotification(_ title: String, body: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                
                let uuidString = UUID().uuidString
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                notificationCenter.add(request, withCompletionHandler: { (error) in
                    if error != nil {
                        // Handle the error
                    }
                })
            }
        }
    }
}

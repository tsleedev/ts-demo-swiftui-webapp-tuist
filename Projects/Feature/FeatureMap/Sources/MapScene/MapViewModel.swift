//
//  MapViewModel.swift
//  FeatureMap
//
//  Created by TAE SU LEE on 5/14/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSLocation
import Foundation
import MapKit
import Combine

final class MapViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    
    private let locationService = TSLocationService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 초기 지역 설정, 예를 들어 서울 중심부
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        bind()
    }
}

extension MapViewModel {
    func startUpdatingLocation() {
        locationService.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationService.stopUpdatingLocation()
    }
    
    func bind() {
        locationService.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self else { return }
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
            .store(in: &cancellables)
    }
}

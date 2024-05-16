//
//  MapView.swift
//  FeatureMap
//
//  Created by taesulee on 2024/05/14.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import SwiftUI

struct MapView: View {
    @StateObject var viewModel: MapViewModel = MapViewModel()
    
    var body: some View {
        MapViewRepresentable(region: $viewModel.region)
            .onAppear {
                viewModel.startUpdatingLocation()
            }
            .onDisappear {
                viewModel.stopUpdatingLocation()
            }
    }
}

#if DEBUG
#Preview {
    MapView()
}
#endif

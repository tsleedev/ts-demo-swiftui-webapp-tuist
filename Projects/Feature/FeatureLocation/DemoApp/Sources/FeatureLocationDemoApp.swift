//
//  FeatureLocationDemoApp.swift
//  FeatureLocation
//
//  Created by taesulee on 2024/05/14.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import FeatureLocation
import SwiftUI

@main
struct FeatureLocationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ViewFactory.createLocationView()
        }
    }
}

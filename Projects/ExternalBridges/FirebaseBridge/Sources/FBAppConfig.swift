//
//  FBAppConfig.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import Firebase

public struct FBAppConfig {
    public static func configure() {
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let options = FirebaseOptions(contentsOfFile: filePath)
        else { return }
        FirebaseApp.configure(options: options)
    }
}

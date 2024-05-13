//
//  AppAppDelegate.swift
//  FeatureApp
//
//  Created by TAE SU LEE on 2023/09/20.
//  Copyright © 2023 https://github.com/tsleedev/. All rights reserved.
//

import FeatureApp
import UIComponents
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let viewController = AppViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController.wrapNavigationController
        window?.makeKeyAndVisible()

        return true
    }
}

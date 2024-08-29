//
//  JavaScriptInterface.swift
//  TSWebViewDemo
//
//  Created by TAE SU LEE on 2021/07/08.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import UIKit

// Create protocol.
// '@objc' keyword is required. because method call is based on ObjC.
@objc protocol JavaScriptInterface {
    func screenEvent(_ response: Any)
    func logEvent(_ response: Any)
    func setUserProperty(_ response: Any)
    func getPermissionLocation(_ response: Any)
    func getLocation(_ response: Any)
    func setDestination(_ response: Any)
    func removeDestination(_ response: Any)
    func startUpdatingLocation(_ response: Any)
    func stopUpdatingLocation(_ response: Any)
    func revealSettings(_ response: Any)
    func openPhoneSettings(_ response: Any)
}

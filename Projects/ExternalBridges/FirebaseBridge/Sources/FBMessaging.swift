//
//  FBMessaging.swift
//  FirebaseBridge
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation
import Combine
import FirebaseMessaging

public class FBMessaging: NSObject, MessagingDelegate {
    public let fcmTokenPublisher = PassthroughSubject<String?, Never>()
    
    public override init() {
        super.init()
        Messaging.messaging().delegate = self
    }
    
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        fcmTokenPublisher.send(fcmToken)
    }
}

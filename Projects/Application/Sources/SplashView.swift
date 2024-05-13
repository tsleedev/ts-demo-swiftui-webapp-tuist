//
//  SplashView.swift
//  WebAppDemo
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(UIColor(resource: .launchScreenBackground))
                .ignoresSafeArea()
            Text("App is now Launching...")
        }
    }
}

#Preview {
    SplashView()
}

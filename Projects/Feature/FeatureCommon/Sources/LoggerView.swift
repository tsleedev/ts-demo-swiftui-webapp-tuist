//
//  LoggerView.swift
//  FeatureCommon
//
//  Created by TAE SU LEE on 5/16/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSLogger
import SwiftUI

public struct LoggerView: View {
    @State private var logText: String = ""
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Logs")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
                Text(logText)
                    .font(.caption2)
                    .padding()
            }
        }
        .onAppear {
            loadLogs()
        }
    }
    
    func loadLogs() {
        logText = TSFileLogger.shared.readLogs()
    }
}

#Preview {
    LoggerView()
}

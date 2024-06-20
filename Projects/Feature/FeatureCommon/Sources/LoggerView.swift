//
//  LoggerView.swift
//  FeatureCommon
//
//  Created by TAE SU LEE on 5/16/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import TSCoreLogger
import SwiftUI

public struct LoggerView: View {
    @State private var logText: String = ""
    @State private var showShareSheet = false
    
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
            
            Button(action: {
                shareLogFile()
            }) {
                Text("Share Log File")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            loadLogs()
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: [getLogFileURL()])
        }
    }
    
    func loadLogs() {
        logText = TSFileLogger.shared.readLogs()
    }
    
    func getLogFileURL() -> URL {
        return TSFileLogger.shared.getLogFileURL()
    }

    func shareLogFile() {
        showShareSheet = true
    }
}

#Preview {
    LoggerView()
}

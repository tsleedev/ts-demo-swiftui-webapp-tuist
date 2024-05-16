//
//  TSFileLogger.swift
//  TSLogger
//
//  Created by TAE SU LEE on 5/16/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public class TSFileLogger {
    public static let shared = TSFileLogger()
    private let maxLines = 1000 // 최대 줄 수

    private init() {}

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func getLogFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("location_log.txt")
    }

    public func log(_ message: String) {
        // 비동기적으로 파일에 기록
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.writeLog(message)
        }
    }

    private func writeLog(_ log: String) {
        let logFileURL = getLogFileURL()
        let logMessage = "\(Date()): \(log)\n"
        guard let data = logMessage.data(using: .utf8) else { return }
        
        // 파일이 존재하는지 확인하고 없으면 생성
        if !FileManager.default.fileExists(atPath: logFileURL.path) {
            FileManager.default.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }
        
        // 파일의 내용을 줄 단위로 읽기
        guard let fileHandle = try? FileHandle(forReadingFrom: logFileURL) else { return }
        let fileData = fileHandle.readDataToEndOfFile()
        fileHandle.closeFile()
        
        guard var fileContent = String(data: fileData, encoding: .utf8) else { return }
        
        // 줄 단위로 나누기
        var lines = fileContent.split(separator: "\n").map(String.init)
        
        // 새로운 로그 메시지를 상단에 추가
        lines.insert(logMessage.trimmingCharacters(in: .newlines), at: 0)
        
        // 최대 줄 수를 초과하면 하단 줄 삭제
        if lines.count > maxLines {
            lines.removeLast(lines.count - maxLines)
        }
        
        // 수정된 파일 내용을 다시 파일에 쓰기
        fileContent = lines.joined(separator: "\n")
        
        do {
            try fileContent.write(to: logFileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write to log file: \(error)")
        }
    }

    public func readLogs() -> String {
        let logFileURL = getLogFileURL()
        if let logData = try? Data(contentsOf: logFileURL),
           let logString = String(data: logData, encoding: .utf8) {
            return logString
        } else {
            return "No logs available"
        }
    }
}

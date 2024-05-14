import Foundation
import ProjectDescription

// 1. JSON 파일 읽기
let url = URL(fileURLWithPath: "./configVersions.json")
let data = try! Data(contentsOf: url)

// 2. JSON 파싱
struct VersionBuild: Decodable {
    let version: String
    let build: String
}

let decodedConfig = try! JSONDecoder().decode(VersionBuild.self, from: data)

// 3. 설정 적용


public enum AppConfig {
    public static let version = SettingValue(stringLiteral: decodedConfig.version)
    public static let build = SettingValue(stringLiteral: decodedConfig.build)
    
    public static let projectName = "TSWebAppDemo"
    public static let bundleIDPrefix = "com.tsleedev.\(projectName.lowercased())"
    public static let targetVersion = "16.0"
    public static let organizationName = "https://github.com/tsleedev/"
}

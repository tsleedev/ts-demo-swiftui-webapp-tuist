import ProjectDescription

extension NotificationServiceExtensionModule {
    var versionAndBuild: (SettingValue, SettingValue) {
        (AppConfig.version, AppConfig.build)
    }
    
    var targetName: String {
        switch environment {
        case .prod: return "NSE"
        case .stg: return "NSE_Stg"
        case .dev:  return "NSE_Dev"
        }
    }
    
    var bundleId: String {
        switch environment {
        case .prod: return AppConfig.bundleIDPrefix + ".nes"
        case .stg: return AppConfig.bundleIDPrefix + ".stg.nes"
        case .dev:  return AppConfig.bundleIDPrefix + ".dev.nes"
        }
    }
    
    var environmentFolderName: String {
        switch environment {
        case .prod: return "PRO"
        case .stg: return "STG"
        case .dev:  return "DEV"
        }
    }
    
    var infoPlist: [String: Plist.Value] {
        [
            "NSAppTransportSecurity": [
                "NSAllowsArbitraryLoads": true,
                "NSAllowsArbitraryLoadsForMedia": true,
                "NSAllowsArbitraryLoadsInWebContent": true
            ]
        ]
    }
    
    var baseSettings: [String: SettingValue] {
        [
            "CURRENT_PROJECT_VERSION": versionAndBuild.1,
            "DEVELOPMENT_TEAM": "8TTY9NTDGA",
            "MARKETING_VERSION": versionAndBuild.0
        ]
    }
}

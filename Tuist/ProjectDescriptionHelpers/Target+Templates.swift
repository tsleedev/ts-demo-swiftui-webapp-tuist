import ProjectDescription

public extension Target {
    static func makeApp(name: String,
                        bundleId: String? = nil,
                        infoPlist: InfoPlist? = nil,
                        sources: SourceFilesList? = nil,
                        resources: ResourceFileElements? = nil,
                        headers: Headers? = nil,
                        entitlements: Entitlements? = nil,
                        scripts: [TargetScript] = [],
                        dependencies: [TargetDependency] = [],
                        settings: Settings? = nil,
                        launchArguments: [LaunchArgument] = [],
                        additionalFiles: [FileElement] = []) -> Target {
        return .makeTarget(name: name,
                           product: .app,
                           bundleId: bundleId,
                           infoPlist: infoPlist,
                           sources: sources,
                           resources: resources,
                           headers: headers,
                           entitlements: entitlements,
                           scripts: scripts,
                           dependencies: dependencies,
                           settings: settings,
                           launchArguments: launchArguments,
                           additionalFiles: additionalFiles)
    }
    
    static func makeDemoApp(name: String,
                            sources: SourceFilesList?,
                            resources: ResourceFileElements?,
                            dependencies: [TargetDependency] = []) -> Target {
        let infoPlist: [String: Plist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen",
            "NSLocationAlwaysAndWhenInUseUsageDescription": "위치 정보 요청",
            "NSLocationWhenInUseUsageDescription": "위치 정보 요청",
            "UIBackgroundModes": [
                "location",
                "fetch",
            ],
            "BGTaskSchedulerPermittedIdentifiers": [
                "com.yourcompany.app.refresh",
            ]
        ]
        
        let launchArguments: [LaunchArgument] = [
            .launchArgument(name: "-IDEPreferLogStreaming", isEnabled: true),
        ]
        
        return .makeTarget(name: "\(name)DemoApp",
                           product: .app,
                           infoPlist: .extendingDefault(with: infoPlist),
                           sources: sources,
                           resources: resources,
                           dependencies: dependencies,
                           launchArguments: launchArguments)
    }
    
    static func makeAppExtension(name: String,
                                 bundleId: String? = nil,
                                 infoPlist: InfoPlist? = nil,
                                 sources: SourceFilesList?,
                                 resources: ResourceFileElements?,
                                 headers: Headers? = nil,
                                 dependencies: [TargetDependency],
                                 settings: Settings? = nil) -> Target {
        return .makeTarget(name: name,
                           product: .appExtension,
                           bundleId: bundleId,
                           infoPlist: infoPlist,
                           sources: sources,
                           resources: resources,
                           headers: headers,
                           dependencies: dependencies,
                           settings: settings)
    }
    
    static func makeStaticFramework(name: String,
                                    sources: SourceFilesList?,
                                    resources: ResourceFileElements?,
                                    headers: Headers? = nil,
                                    dependencies: [TargetDependency],
                                    settings: Settings? = nil) -> Target {
        return .makeTarget(name: name,
                           product: .staticFramework,
                           infoPlist: .default,
                           sources: sources,
                           resources: resources,
                           headers: headers,
                           dependencies: dependencies,
                           settings: settings)
    }
    
    static func makeDynamicFramework(name: String,
                                     sources: SourceFilesList?,
                                     resources: ResourceFileElements?,
                                     headers: Headers? = nil,
                                     dependencies: [TargetDependency],
                                     settings: Settings? = nil) -> Target {
        return .makeTarget(name: name,
                           product: .framework,
                           infoPlist: .default,
                           sources: sources,
                           resources: resources,
                           headers: headers,
                           dependencies: dependencies,
                           settings: settings)
    }
    
    static func makeTests(name: String,
                          sources: SourceFilesList?,
                          resources: ResourceFileElements?) -> Target {
        return .makeTarget(name: "\(name)Tests",
                           product: .unitTests,
                           infoPlist: .default,
                           sources: sources,
                           resources: resources,
                           dependencies: [
                            .target(name: "\(name)")
                           ])
    }
    
    static func makeUITests(name: String,
                            bundleId: String? = nil,
                            sources: SourceFilesList?,
                            resources: ResourceFileElements?,
                            dependencies: [TargetDependency],
                            settings: Settings? = nil) -> Target {
        return .makeTarget(name: "\(name)UITests",
                           product: .uiTests,
                           bundleId: bundleId,
                           infoPlist: .default,
                           sources: sources,
                           resources: resources,
                           dependencies: dependencies,
                           settings: settings)
    }
}

private extension Target {
    static func makeTarget(name: String,
                           product: Product,
                           bundleId: String? = nil,
                           infoPlist: InfoPlist? = nil,
                           sources: SourceFilesList? = nil,
                           resources: ResourceFileElements? = nil,
                           headers: Headers? = nil,
                           entitlements: Entitlements? = nil,
                           scripts: [TargetScript] = [],
                           dependencies: [TargetDependency] = [],
                           settings: Settings? = nil,
                           launchArguments: [LaunchArgument] = [],
                           additionalFiles: [FileElement] = []) -> Target {
        return .target(
            name: name,
            destinations: [.iPhone],
            product: product,
            bundleId: bundleId ?? (AppConfig.bundleIDPrefix + "." + name),
            deploymentTargets: .iOS(AppConfig.targetVersion),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            copyFiles: nil,
            headers: headers,
            entitlements: entitlements,
            scripts: scripts,
            dependencies: dependencies,
            settings: settings,
            coreDataModels: [],
            environmentVariables: [:],
            launchArguments: launchArguments,
            additionalFiles: [],
            buildRules: [],
            mergedBinaryType: .disabled,
            mergeable: false
        )
    }
}

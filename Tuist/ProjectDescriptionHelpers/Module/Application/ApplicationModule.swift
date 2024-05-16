import ProjectDescription

let ApplicationProjectPath = "Projects/Application"

public struct ApplicationModule {
    let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension ApplicationModule: Moduleable {
    public var sources: SourceFilesList? {
        let globs: [ProjectDescription.SourceFileGlob] = [
            .glob(.relativeToRoot("\(ApplicationProjectPath)/Sources/**"))
        ]
        return SourceFilesList.sourceFilesList(globs: globs)
    }
    
    public var resources: ResourceFileElements? {
        return [
            .glob(pattern: .relativeToRoot("\(ApplicationProjectPath)/Environments/\(environmentFolderName)/**")),
            .glob(pattern: .relativeToRoot("\(ApplicationProjectPath)/Resources/**")),
        ]
    }
    
    public var scripts: [TargetScript] {
        let scripts: [TargetScript] = [
            .post(script: "${SRCROOT}/../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run",
                  name: "Firebase Crashlytics",
                  inputPaths: [
                    "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                    "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
                    "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
                    "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
                    "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)",
                  ])
        ]
        return scripts
    }
    
    public var dependencies: [TargetDependency] {
        var dependencies = [
            Module.Core.TSAnalytics.project,
            Module.Core.TSCrashlytics.project,
            Module.Core.TSDeepLinks.project,
            Module.Core.TSMessaging.project,
            Module.Core.TSNetwork.project,
            External.Alamofire.dependency,
            
            .sdk(name: "WebKit", type: .framework, status: .required),
        ]
        
        dependencies += [
            Module.Feature.Common.project,
            Module.Feature.Main.project,
        ]
        dependencies += Module.UI.allCases.map { $0.project }
        
        // AppExtension
//        dependencies.append(.target(name: NotificationServiceExtensionModule(environment: environment).targetName))
        return dependencies
    }
    
    public var settings: Settings? {
        return .settings(
            base: baseSettings,
            defaultSettings: .recommended
        )
    }
    
    public var additionalFiles: [FileElement] {
        return [
            .glob(pattern: .relativeToRoot(".swiftlint.yml")),
            .glob(pattern: .relativeToRoot("configVersions.json")),
        ]
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeApp(
            name: targetName,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: sources,
            resources: resources,
            headers: headers,
            entitlements: .file(path: .relativeToRoot("\(ApplicationProjectPath)/TSWebAppDemo.entitlements")),
            dependencies: dependencies,
            settings: settings,
            launchArguments: launchArguments,
            additionalFiles: additionalFiles)
    }
    
    public var project: TargetDependency {
        return .project(target: AppConfig.projectName, path: .relativeToManifest(""))
    }
}

extension ApplicationModule: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: AppConfig.projectName,
            sources: testsSources,
            resources: nil
        )
    }
}

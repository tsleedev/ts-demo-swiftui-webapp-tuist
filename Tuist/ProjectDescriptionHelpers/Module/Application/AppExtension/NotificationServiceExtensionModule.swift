import ProjectDescription

let NSEProjectPath = "Projects/Application/AppExtension/NSE"

public struct NotificationServiceExtensionModule {
    let environment: Environment
    
    public init(environment: Environment) {
        self.environment = environment
    }
}

extension NotificationServiceExtensionModule: Moduleable {
    public var sources: SourceFilesList? {
        let globs: [ProjectDescription.SourceFileGlob] = [
            .glob(.relativeToRoot("\(NSEProjectPath)/Sources/**"))
        ]
        return SourceFilesList.sourceFilesList(globs: globs)
    }
    
    public var settings: Settings? {
        return .settings(base: baseSettings, defaultSettings: .recommended)
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeApp(
            name: targetName,
            bundleId: bundleId,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: sources,
            resources: nil,
            dependencies: dependencies,
            settings: settings)
    }
    
    public var project: TargetDependency {
        return .project(target: AppConfig.projectName, path: .relativeToManifest(""))
    }
}

extension NotificationServiceExtensionModule: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: AppConfig.projectName,
            sources: testsSources,
            resources: nil
        )
    }
}

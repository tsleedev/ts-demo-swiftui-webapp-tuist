import ProjectDescription

private let ProjectPath = "Projects/Feature"
public extension Module {
    enum Feature: String, CaseIterable {
        case Common = "FeatureCommon"
        case Location = "FeatureLocation"
        case Main = "FeatureMain"
        case Settings = "FeatureSettings"
        case WebView = "FeatureWebView"
    }
}

extension Module.Feature: Moduleable {
    public var resources: ResourceFileElements? {
        let resources: ResourceFileElements?
        switch self {
        case .Common, .Main, .Location, .Settings:
            resources = []
        case .WebView:
            resources = [
                .glob(pattern: .relativeToManifest("Resources/**")),
            ]
        }
        return resources
    }
    
    public var dependencies: [TargetDependency] {
        let commonDependencies: [TargetDependency] = [
        ]
        
        let targetSpecificDependencies: [TargetDependency]
        switch self {
        case .Common:
            targetSpecificDependencies = [
                Module.UI.TSWebView.project,
            ]
        case .Main:
            targetSpecificDependencies = [
                Module.Feature.Common.project,
                Module.Feature.Settings.project,
                Module.Feature.WebView.project,
            ]
        case .Location, .Settings:
            targetSpecificDependencies = []
        case .WebView:
            targetSpecificDependencies = [
                Module.Core.TSAnalytics.project,
                Module.Core.TSCrashlytics.project,
                Module.Core.TSUtility.project,
                Module.Feature.Common.project,
                Module.UI.TSUIKitExtensions.project,
                Module.UI.TSWebView.project,
            ]
        }
        return commonDependencies + targetSpecificDependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.rawValue,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }
    
    public var project: TargetDependency {
        return .project(target: self.rawValue, path: .relativeToRoot("\(ProjectPath)/\(self.rawValue)"))
    }
}

extension Module.Feature: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.rawValue,
            sources: testsSources,
            resources: nil
        )
    }
}

extension Module.Feature: UITestsModuleable {
    public var uiTests: ProjectDescription.Target {
        return Target.makeUITests(
            name: self.rawValue,
            sources: uiTestsSources,
            resources: nil,
            dependencies: [
                .target(name: self.rawValue),
            ]
        )
    }
}

extension Module.Feature: DemoAppModuleable {
    public var demoApp: ProjectDescription.Target {
        Target.makeDemoApp(
            name: self.rawValue,
            sources: demoAppSources,
            resources: demoAppResources,
            dependencies: [
                .target(name: self.rawValue),
            ]
        )
    }
}

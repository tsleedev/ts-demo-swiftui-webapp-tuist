import ProjectDescription

private let ProjectPath = "Projects/Feature"
public extension Module {
    enum Feature: String, CaseIterable {
        case Common
        case Main
        case Map
        case Settings
        case WebView
        
        public var name: String {
            return "Feature\(self.rawValue)"
        }
    }
}

extension Module.Feature: Moduleable {
    public var resources: ResourceFileElements? {
        let resources: ResourceFileElements?
        switch self {
        case .Common, .Main, .Settings:
            resources = []
        case .Map, .WebView:
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
                
            ]
        case .Main:
            targetSpecificDependencies = [
                Module.Feature.Common.project,
                Module.Feature.Settings.project,
                Module.Feature.WebView.project,
            ]
        case .Map:
            targetSpecificDependencies = [
                Module.TSService.Location.project,
                Module.Feature.Common.project,
            ]
        case .Settings:
            targetSpecificDependencies = []
        case .WebView:
            targetSpecificDependencies = [
                Module.TSCore.UIKitExtensions.project,
                Module.TSCore.Utilities.project,
                Module.TSService.Analytics.project,
                Module.TSService.Crashlytics.project,
                Module.TSService.Location.project,
                Module.TSUI.WebView.project,
                Module.Feature.Common.project,
            ]
        }
        return commonDependencies + targetSpecificDependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.name,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }
    
    public var project: TargetDependency {
        return .project(
            target: self.name,
            path: .relativeToRoot("\(ProjectPath)/\(self.name)")
        )
    }
}

extension Module.Feature: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.name,
            sources: testsSources,
            resources: nil
        )
    }
}

extension Module.Feature: UITestsModuleable {
    public var uiTests: ProjectDescription.Target {
        return Target.makeUITests(
            name: self.name,
            sources: uiTestsSources,
            resources: nil,
            dependencies: [
                .target(name: self.name),
            ]
        )
    }
}

extension Module.Feature: DemoAppModuleable {
    public var demoApp: ProjectDescription.Target {
        Target.makeDemoApp(
            name: self.name,
            sources: demoAppSources,
            resources: demoAppResources,
            dependencies: [
                .target(name: self.name),
            ]
        )
    }
}

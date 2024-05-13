import ProjectDescription

private let ProjectPath = "Projects/UI"
public extension Module {
    enum UI: String, CaseIterable {
        case TSUIKitExtensions
        case TSWebView
    }
}

extension Module.UI: Moduleable {
    public var resources: ResourceFileElements? {
        let resources: ResourceFileElements?
        switch self {
        case .TSUIKitExtensions, .TSWebView:
            resources = nil
        }
        return resources
    }
    
    public var dependencies: [TargetDependency] {
        let dependencies: [TargetDependency]
        switch self {
        case .TSUIKitExtensions:
            dependencies = []
        case .TSWebView:
            dependencies = [
                Module.Core.TSLogger.project,
            ]
        }
        return dependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.rawValue,
            sources: sources,
            resources: resources,
            dependencies: dependencies)
    }
    
    public var project: TargetDependency {
        return .project(target: self.rawValue, path: .relativeToRoot("\(ProjectPath)/\(self.rawValue)"))
    }
}

extension Module.UI: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.rawValue,
            sources: testsSources,
            resources: nil
        )
    }
}

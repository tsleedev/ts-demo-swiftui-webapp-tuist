import ProjectDescription

private let ProjectPath = "Projects/TSUI"
public extension Module {
    enum TSUI: String, CaseIterable {
        case WebView
        
        public var name: String {
            return "TSUI\(self.rawValue)"
        }
    }
}

extension Module.TSUI: Moduleable {
    public var resources: ResourceFileElements? {
        let resources: ResourceFileElements?
        switch self {
        case .WebView:
            resources = nil
        }
        return resources
    }
    
    public var dependencies: [TargetDependency] {
        let dependencies: [TargetDependency]
        switch self {
        case .WebView:
            dependencies = [
                Module.TSCore.Logger.project,
            ]
        }
        return dependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.name,
            sources: sources,
            resources: resources,
            dependencies: dependencies)
    }
    
    public var project: TargetDependency {
        return .project(
            target: self.name,
            path: .relativeToRoot("\(ProjectPath)/\(self.name)")
        )
    }
}

extension Module.TSUI: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.name,
            sources: testsSources,
            resources: nil
        )
    }
}

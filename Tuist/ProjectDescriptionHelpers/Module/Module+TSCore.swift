import ProjectDescription

private let ProjectPath = "Projects/TSCore"
public extension Module {
    enum TSCore: String, CaseIterable {
        case Logger
        case UIKitExtensions
        case Utilities
        
        public var name: String {
            return "TSCore\(self.rawValue)"
        }
    }
}

extension Module.TSCore: Moduleable {
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.name,
            sources: sources,
            resources: nil,
            dependencies: [])
    }
    
    public var project: TargetDependency {
        return .project(
            target: self.name,
            path: .relativeToRoot("\(ProjectPath)/\(self.name)")
        )
    }
}

extension Module.TSCore: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.name,
            sources: testsSources,
            resources: nil
        )
    }
}

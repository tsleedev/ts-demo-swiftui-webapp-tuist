import ProjectDescription

private let ProjectPath = "Projects/TSService"
public extension Module {
    enum TSService: String, CaseIterable {
        case Analytics
        case Crashlytics
        case DeepLinks
        case Location
        case Messaging
        case Network
        
        public var name: String {
            return "TSService\(self.rawValue)"
        }
    }
}

extension Module.TSService: Moduleable {
    public var dependencies: [TargetDependency] {
        let dependencies: [TargetDependency]
        switch self {
        case .Analytics, .Crashlytics, .DeepLinks, .Messaging:
            dependencies = [
                Module.ExternalBridges.Firebase.project,
            ]
        case .Location:
            dependencies = [
                Module.TSCore.Logger.project,
            ]
        case .Network:
            dependencies = [
                Module.TSCore.Configuration.project,
                Module.TSCore.Logger.project,
                External.Moya.dependency
            ]
        }
        return dependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.name,
            sources: sources,
            resources: nil,
            dependencies: dependencies)
    }
    
    public var project: TargetDependency {
        return .project(
            target: self.name,
            path: .relativeToRoot("\(ProjectPath)/\(self.name)")
        )
    }
}

extension Module.TSService: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.name,
            sources: testsSources,
            resources: nil
        )
    }
}

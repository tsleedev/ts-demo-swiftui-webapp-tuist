import ProjectDescription

private let ProjectPath = "Projects/Core"
public extension Module {
    enum Core: String, CaseIterable {
        case TSAnalytics
        case TSCrashlytics
        case TSDeepLinks
        case TSLogger
        case TSMessaging
        case TSNetwork
        case TSUtility
    }
}

extension Module.Core: Moduleable {
    public var dependencies: [TargetDependency] {
        let dependencies: [TargetDependency]
        switch self {
        case .TSAnalytics, .TSCrashlytics, .TSDeepLinks, .TSMessaging:
            dependencies = [
                Module.ExternalBridges.Firebase.project,
            ]
        case .TSNetwork:
            dependencies = [
                Module.Core.TSLogger.project,
                External.Moya.dependency
            ]
        case .TSLogger, .TSUtility:
            dependencies = []
        }
        return dependencies
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.rawValue,
            sources: sources,
            resources: nil,
            dependencies: dependencies)
    }
    
    public var project: TargetDependency {
        return .project(target: self.rawValue, path: .relativeToRoot("\(ProjectPath)/\(self.rawValue)"))
    }
}

extension Module.Core: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.rawValue,
            sources: testsSources,
            resources: nil
        )
    }
}

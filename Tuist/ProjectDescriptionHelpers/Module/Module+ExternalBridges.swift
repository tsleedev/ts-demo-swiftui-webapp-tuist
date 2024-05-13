import ProjectDescription

private let ProjectPath = "Projects/ExternalBridges"
public extension Module {
    enum ExternalBridges: String, CaseIterable {
        case Firebase = "FirebaseBridge"
    }
}

extension Module.ExternalBridges: Moduleable {
    public var dependencies: [TargetDependency] {
        let dependencies: [TargetDependency]
        switch self {
        case .Firebase:
            dependencies = [
                External.FirebaseAnalytics.dependency,
                External.FirebaseCrashlytics.dependency,
                External.FirebaseDynamicLinks.dependency,
                External.FirebaseMessaging.dependency,
            ]
        }
        return dependencies
    }
    
    public var settings: Settings? {
        let settings: Settings?
        switch self {
        case .Firebase:
            settings = .settings(
                base: [
                    "OTHER_LDFLAGS": "-ObjC",
                ]
            )
        }
        return settings
    }
    
    public var target: ProjectDescription.Target {
        return Target.makeDynamicFramework(
            name: self.rawValue,
            sources: sources,
            resources: nil,
            dependencies: dependencies,
            settings: settings
        )
    }
    
    public var project: TargetDependency {
        return .project(target: self.rawValue, path: .relativeToRoot("\(ProjectPath)/\(self.rawValue)"))
    }
}

extension Module.ExternalBridges: TestsModuleable {
    public var tests: ProjectDescription.Target {
        return Target.makeTests(
            name: self.rawValue,
            sources: testsSources,
            resources: nil
        )
    }
}

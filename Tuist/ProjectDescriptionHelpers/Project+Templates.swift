import ProjectDescription

public extension Project {
    static func app(name: String,
                    targets: [Target]) -> Project {
        return Project(
            name: name,
            organizationName: AppConfig.organizationName,
            targets: targets
        )
    }
}

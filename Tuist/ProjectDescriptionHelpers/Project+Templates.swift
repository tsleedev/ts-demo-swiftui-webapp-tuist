import ProjectDescription

public extension Project {
    static func app(name: String,
                    targets: [Target]) -> Project {
        return Project(
            name: name,
            organizationName: "https://github.com/tsleedev",
            targets: targets
        )
    }
}

import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSCore.Configuration.target,
        Module.TSCore.Configuration.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSCore.Configuration.rawValue,
    targets: targets
)

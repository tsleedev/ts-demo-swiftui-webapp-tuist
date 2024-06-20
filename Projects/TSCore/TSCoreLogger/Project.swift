import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSCore.Logger.target,
        Module.TSCore.Logger.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSCore.Logger.rawValue,
    targets: targets
)

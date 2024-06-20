import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSCore.Utilities.target,
        Module.TSCore.Utilities.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSCore.Utilities.rawValue,
    targets: targets
)

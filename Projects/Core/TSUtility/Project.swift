import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSUtility.target,
        Module.Core.TSUtility.tests
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSUtility.rawValue,
    targets: targets
)

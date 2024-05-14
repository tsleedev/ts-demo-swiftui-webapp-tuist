import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSLocation.target,
        Module.Core.TSLocation.tests,
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSLocation.rawValue,
    targets: targets
)

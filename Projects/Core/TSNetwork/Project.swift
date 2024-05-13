import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSNetwork.target,
        Module.Core.TSNetwork.tests
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSNetwork.rawValue,
    targets: targets
)

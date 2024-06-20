import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.Network.target,
        Module.TSService.Network.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.Network.rawValue,
    targets: targets
)

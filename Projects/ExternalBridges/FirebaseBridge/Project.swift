import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.ExternalBridges.Firebase.target,
        Module.ExternalBridges.Firebase.tests
    ]
    return target
}

let project = Project.app(
    name: Module.ExternalBridges.Firebase.rawValue,
    targets: targets
)

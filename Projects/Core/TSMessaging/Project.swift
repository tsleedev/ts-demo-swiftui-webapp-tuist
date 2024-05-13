import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSMessaging.target,
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSMessaging.rawValue,
    targets: targets
)

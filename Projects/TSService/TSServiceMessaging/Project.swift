import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.Messaging.target,
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.Messaging.rawValue,
    targets: targets
)

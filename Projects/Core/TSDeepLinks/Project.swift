import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSDeepLinks.target,
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSDeepLinks.rawValue,
    targets: targets
)

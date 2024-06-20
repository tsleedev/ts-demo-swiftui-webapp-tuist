import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.DeepLinks.target,
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.DeepLinks.rawValue,
    targets: targets
)

import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.Analytics.target,
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.Analytics.rawValue,
    targets: targets
)

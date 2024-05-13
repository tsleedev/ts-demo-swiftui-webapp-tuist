import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Feature.Common.target,
    ]
    return target
}

let project = Project.app(
    name: Module.Feature.Common.rawValue,
    targets: targets
)

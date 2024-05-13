import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSAnalytics.target,
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSAnalytics.rawValue,
    targets: targets
)

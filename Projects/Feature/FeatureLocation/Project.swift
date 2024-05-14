import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Feature.Location.target,
        Module.Feature.Location.tests,
        Module.Feature.Location.demoApp,
    ]
    return target
}

let project = Project.app(
    name: Module.Feature.Location.rawValue,
    targets: targets
)

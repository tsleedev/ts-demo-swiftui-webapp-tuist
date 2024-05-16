import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Feature.Map.target,
        Module.Feature.Map.tests,
        Module.Feature.Map.demoApp,
    ]
    return target
}

let project = Project.app(
    name: Module.Feature.Map.rawValue,
    targets: targets
)

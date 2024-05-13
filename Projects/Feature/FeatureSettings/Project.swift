import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Feature.Settings.target,
        Module.Feature.Settings.tests,
//        Module.Feature.Settings.uiTests,
        Module.Feature.Settings.demoApp,
    ]
    return target
}

let project = Project.app(
    name: Module.Feature.Settings.rawValue,
    targets: targets
)

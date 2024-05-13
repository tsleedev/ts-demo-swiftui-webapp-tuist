import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.UI.TSUIKitExtensions.target,
        Module.UI.TSUIKitExtensions.tests
    ]
    return target
}

let project = Project.app(
    name: Module.UI.TSUIKitExtensions.rawValue,
    targets: targets
)

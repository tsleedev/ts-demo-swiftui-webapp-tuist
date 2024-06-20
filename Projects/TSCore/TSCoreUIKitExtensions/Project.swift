import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSCore.UIKitExtensions.target,
        Module.TSCore.UIKitExtensions.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSCore.UIKitExtensions.rawValue,
    targets: targets
)

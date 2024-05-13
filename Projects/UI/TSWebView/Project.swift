import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.UI.TSWebView.target,
        Module.UI.TSWebView.tests
    ]
    return target
}

let project = Project.app(
    name: Module.UI.TSWebView.rawValue,
    targets: targets
)

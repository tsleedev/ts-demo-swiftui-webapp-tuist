import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSUI.WebView.target,
        Module.TSUI.WebView.tests
    ]
    return target
}

let project = Project.app(
    name: Module.TSUI.WebView.rawValue,
    targets: targets
)

import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Feature.WebView.target,
        Module.Feature.WebView.tests,
//        Module.Feature.WebView.uiTests,
        Module.Feature.WebView.demoApp,
    ]
    return target
}

let project = Project.app(
    name: Module.Feature.WebView.rawValue,
    targets: targets
)

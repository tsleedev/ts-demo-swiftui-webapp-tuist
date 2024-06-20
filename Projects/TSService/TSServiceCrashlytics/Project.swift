import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.Crashlytics.target,
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.Crashlytics.rawValue,
    targets: targets
)

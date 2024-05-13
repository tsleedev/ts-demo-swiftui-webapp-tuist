import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSCrashlytics.target,
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSCrashlytics.rawValue,
    targets: targets
)

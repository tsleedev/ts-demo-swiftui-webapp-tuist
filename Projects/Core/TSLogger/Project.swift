import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.Core.TSLogger.target,
        Module.Core.TSLogger.tests
    ]
    return target
}

let project = Project.app(
    name: Module.Core.TSLogger.rawValue,
    targets: targets
)

import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        Module.TSService.Location.target,
        Module.TSService.Location.tests,
    ]
    return target
}

let project = Project.app(
    name: Module.TSService.Location.rawValue,
    targets: targets
)

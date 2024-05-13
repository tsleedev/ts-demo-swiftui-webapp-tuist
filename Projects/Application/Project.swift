import ProjectDescription
import ProjectDescriptionHelpers

var targets: [Target] {
    let target: [Target] = [
        ApplicationModule(environment: .prod).target,
        ApplicationModule(environment: .stg).target,
        ApplicationModule(environment: .dev).target,
//        NotificationServiceExtensionModule(environment: .prod).target,
//        NotificationServiceExtensionModule(environment: .stg).target,
//        NotificationServiceExtensionModule(environment: .dev).target,
    ]
    return target
}

let project = Project.app(
    name: AppConfig.projectName,
    targets: targets
)

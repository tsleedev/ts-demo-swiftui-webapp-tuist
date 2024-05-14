import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

private let PathPrefix = "Projects/Feature/Feature"
private let creatorName: Template.Attribute.Value = {
    let creatorName = NSUserName()
    return .string(creatorName)
}()
private let currentDate: Template.Attribute.Value = {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let formattedDate = dateFormatter.string(from: currentDate)
    return .string(formattedDate)
}()
private let currentYear: Template.Attribute.Value = {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let formattedDate = dateFormatter.string(from: currentDate)
    return .string(formattedDate)
}()
private let organizationName: Template.Attribute.Value = {
    let organizationName = AppConfig.organizationName
    return .string(organizationName)
}()
private let templateName = Template.Attribute.required("name")

private let template = Template(
    description: "Feature template",
    attributes: [
        templateName,
        .optional("creatorName", default: creatorName),
        .optional("currentDate", default: currentDate),
        .optional("currentYear", default: currentYear),
        .optional("organizationName", default: organizationName),
    ],
    items: [
        .file(path: "\(PathPrefix)\(templateName)/DemoApp/Sources/Feature\(templateName)DemoApp.swift",
              templatePath: "DemoApp.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/DemoApp/Resources/LaunchScreen.storyboard",
              templatePath: "DemoAppLaunchScreen.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Sources/Factories/ViewFactory.swift",
              templatePath: "ViewFactory.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Sources/\(templateName)Scene/\(templateName)View.swift",
              templatePath: "View.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Tests/\(templateName)Tests.swift",
              templatePath: "Tests.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Project.swift",
              templatePath: "Project.stencil")
    ]
)

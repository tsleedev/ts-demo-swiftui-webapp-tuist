import Foundation
import ProjectDescription
import ProjectDescriptionHelpers

private let PathPrefix = "Projects/"
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
    description: "Application template",
    attributes: [
        templateName,
        .optional("creatorName", default: creatorName),
        .optional("currentDate", default: currentDate),
        .optional("currentYear", default: currentYear),
        .optional("organizationName", default: organizationName),
    ],
    items: [
        .file(path: "\(PathPrefix)\(templateName)/Sources/AppDelegate.swift",
              templatePath: "AppDelegate.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Resources/LaunchScreen.storyboard",
              templatePath: "LaunchScreen.stencil"),
        .file(path: "\(PathPrefix)\(templateName)/Tests/\(templateName)Tests.swift",
              templatePath: "Tests.stencil"),
        .file(path: "Projects/\(templateName)/Project.swift",
              templatePath: "Project.stencil")
    ]
)

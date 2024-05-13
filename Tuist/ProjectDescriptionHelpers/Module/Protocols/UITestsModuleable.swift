import ProjectDescription

public protocol UITestsModuleable: Moduleable {
    var uiTestsSources: SourceFilesList? { get }
    var uiTestsResources: ResourceFileElements? { get }
    var uiTests: Target { get }
}

public extension UITestsModuleable {
    var uiTestsSources: SourceFilesList? {
        return [.glob(.relativeToManifest("UITests/**"))]
    }
    
    var uiTestsResources: ResourceFileElements? {
        nil
    }
}

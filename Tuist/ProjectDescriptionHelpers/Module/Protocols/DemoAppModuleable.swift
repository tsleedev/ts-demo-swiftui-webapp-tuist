import ProjectDescription

public protocol DemoAppModuleable: Moduleable {
    var demoAppSources: SourceFilesList? { get }
    var demoAppResources: ResourceFileElements? { get }
    var demoApp: Target { get }
}

public extension DemoAppModuleable {
    var demoAppSources: SourceFilesList? {
        return [.glob(.relativeToManifest("DemoApp/Sources/**"))]
    }
    
    var demoAppResources: ResourceFileElements? {
        return [.glob(pattern: .relativeToManifest("DemoApp/Resources/**"))]
    }
}

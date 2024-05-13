import ProjectDescription

public protocol Moduleable {
    var sources: SourceFilesList? { get }
    var resources: ResourceFileElements? { get }
    var headers: Headers? { get }
    var scripts: [TargetScript] { get }
    var dependencies: [TargetDependency] { get }
    var settings: Settings? { get }
    
    var target: Target { get }
    var project: TargetDependency { get }
}

public extension Moduleable {
    var sources: SourceFilesList? {
        return [.glob(.relativeToManifest("Sources/**"))]
    }
    
    var resources: ResourceFileElements? {
        return [.glob(pattern: .relativeToManifest("Resources/**"))]
    }
    
    var headers: Headers? {
        return nil
    }
    
    var scripts: [TargetScript] {
        return []
    }
    
    var dependencies: [TargetDependency] {
        return []
    }
    
    var settings: Settings? {
        return nil
    }
}

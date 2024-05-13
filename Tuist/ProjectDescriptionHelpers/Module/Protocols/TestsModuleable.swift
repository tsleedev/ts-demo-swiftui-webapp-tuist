import ProjectDescription

public protocol TestsModuleable: Moduleable {
    var testsSources: SourceFilesList? { get }
    var testsResources: ResourceFileElements? { get }
    var tests: Target { get }
}

public extension TestsModuleable {
    var testsSources: SourceFilesList? {
        return [.glob(.relativeToManifest("Tests/**"))]
    }
    
    var testsResources: ResourceFileElements? {
        nil
    }
}

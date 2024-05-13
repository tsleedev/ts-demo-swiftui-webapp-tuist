import ProjectDescription

public enum External: String {
    case Alamofire
    case FirebaseAnalytics
    case FirebaseCrashlytics
    case FirebaseDynamicLinks
    case FirebaseMessaging
    case Moya
}

public extension External {
    var dependency: TargetDependency {
        .external(name: self.rawValue)
    }
}

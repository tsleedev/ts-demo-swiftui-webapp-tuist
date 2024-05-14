//
//  ViewFactory.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 5/8/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import FeatureCommon
import Foundation
import SwiftUI

public struct ViewFactory {
    public static func createWebView(coordinator: CoordinatorProtocol, url: URL) -> some View {
        let viewModel = WebViewModel(coordinator: coordinator, url: url)
        return WebView(viewModel: viewModel)
    }
    
#if DEBUG
    public static func createWebStateForLocalHtml() -> URL {
        let htmlPath = Bundle.module.path(forResource: "testHtml", ofType: "html")!
        let url = URL(fileURLWithPath: htmlPath)
        return url
    }
#endif
}

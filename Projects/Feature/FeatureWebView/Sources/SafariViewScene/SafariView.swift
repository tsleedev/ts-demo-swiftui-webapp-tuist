//
//  SafariView.swift
//  FeatureWebView
//
//  Created by TAE SU LEE on 6/24/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {}
}

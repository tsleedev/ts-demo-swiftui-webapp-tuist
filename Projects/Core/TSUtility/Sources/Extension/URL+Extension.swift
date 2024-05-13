//
//  URL+Extension.swift
//  TSUtility
//
//  Created by TAE SU LEE on 5/7/24.
//  Copyright © 2024 https://github.com/tsleedev/. All rights reserved.
//

import Foundation

public extension URL {
    var absoluteStringByTrimmingQuery: String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
    
    // URL 초기화시 nil이 안되면 url에 한글이 포함된것이라고 예상하고 url 인코딩을 시도 후 URL ㅣㄹ턴
    static func validUrl(urlString: String?) -> URL? {
        guard let urlString = urlString?.trimmingCharacters(in: .whitespacesAndNewlines), !urlString.isEmpty else { return nil }
        var url = URL(string: urlString)
        if url == nil {
            let escapes = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
            url = URL(string: escapes ?? "")
        }
        return url
    }
}

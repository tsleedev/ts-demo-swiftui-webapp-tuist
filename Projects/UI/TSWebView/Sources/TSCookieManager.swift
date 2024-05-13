//
//  TSCookieManager.swift
//  TSFramework
//
//  Created by TAE SU LEE on 2021/07/08.
//

import UIKit
import WebKit

@MainActor
public struct TSCookieManager {}

// MARK: - Private (Web)
private extension TSCookieManager {
    static func _syncWebCookie(cookie: HTTPCookie) async {
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        await cookieStore.setCookie(cookie)
    }
    
    static func _deleteWebCookie(cookies: [HTTPCookie]) async {
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        for cookie in cookies {
            await cookieStore.deleteCookie(cookie)
        }
    }
}

// MARK: - Public (Web)
public extension TSCookieManager {
    static func webCookies(name: String) async -> [HTTPCookie] {
        let cookies = await allWebCookies()
        return cookies.filter { $0.name == name }
    }
    
    static func allWebCookies() async -> [HTTPCookie] {
        let cookieStore = WKWebsiteDataStore.default().httpCookieStore
        return await cookieStore.allCookies()
    }
    
    static func syncWebCookie(_ cookie: HTTPCookie, onlyName: String? = nil) async {
        if let onlyName = onlyName, cookie.name != onlyName { return } // onlyName가 들어오면 cookie.name이 onlyName이 onlyName과 같을 때만 싱크한다.
        await _syncWebCookie(cookie: cookie)
    }
    
    static func syncWebCookies(_ cookies: [HTTPCookie], onlyName: String? = nil) async {
        for cookie in cookies {
            await syncWebCookies(cookies, onlyName: onlyName)
        }
    }
    
    static func deleteWebCookie(name: String) async {
        let cookies = await allWebCookies()
        await _deleteWebCookie(cookies: cookies)
    }
}

// MARK: - Public (API)
public extension TSCookieManager {
    static func apiCookies(name: String) -> [HTTPCookie]? {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return nil }
        return cookies.filter { $0.name == name }
    }
    
    static func apiCookies(domain: String) -> [HTTPCookie]? {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return nil }
        return cookies.filter { $0.domain == domain }
    }
    
    static func syncApiCookie(_ cookie: HTTPCookie, onlyName: String? = nil) {
        if let onlyName = onlyName, cookie.name != onlyName { return } // onlyName가 들어오면 cookie.name이 onlyName이 onlyName과 같을 때만 싱크한다.
        deleteApiCookie(name: cookie.name) // 같은 이름의 이전 쿠키는 지운다.
        HTTPCookieStorage.shared.setCookie(cookie)
    }
    
    static func syncApiCookies(_ cookies: [HTTPCookie], onlyName: String? = nil) {
        for cookie in cookies {
            syncApiCookie(cookie, onlyName: onlyName)
        }
    }
    
    static func deleteApiCookie(name: String) {
        guard let cookies = apiCookies(name: name) else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
    
    static func deleteApiCookie(domain: String) {
        guard let cookies = apiCookies(domain: domain) else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
    
    static func deleteAllApiCookies() {
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
    }
}

// MARK: - Public (Common)
public extension TSCookieManager {
    static func syncCookie(_ cookie: HTTPCookie) async {
        syncApiCookie(cookie)
        await syncWebCookie(cookie)
    }
    
    static func syncCookies(_ cookies: [HTTPCookie]) async {
        syncApiCookies(cookies)
        await syncWebCookies(cookies)
    }
    
    static func deleteCookie(_ name: String) async {
        deleteApiCookie(name: name)
        await deleteWebCookie(name: name)
    }
}

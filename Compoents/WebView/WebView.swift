//
//  WebView.swift
//  ConquestSwift
//
//  Created by changju.kim on 11/19/24.
//

import WebKit

class WebViewController: UIViewController, WKScriptMessageHandler {
    private let bridgeName: String = "SolveBridge"
    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("WebViewController loaded")

        let contentController = WKUserContentController()
        contentController.add(self, name: bridgeName)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: view.frame, configuration: config)
        view.addSubview(webView)

        // 웹뷰 로드
        do {
            guard let filePath = Bundle.main.path(forResource: "index", ofType: "html")
            else {
                // File Error
                print("File reading error")
                return
            }

            let contents = try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            setCookies()
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
        } catch {
            print("File HTML error")
        }
    }

    func setCookies() {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        let cookie = HTTPCookie(properties: [
            .domain: "localhost",
            .path: "/",
            .name: "cookie",
            .value: "cookieValue",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 3600) // 1 hour
        ])!

        cookieStore.setCookie(cookie)
    }

    // JavaScript -> Native
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == bridgeName, let body = message.body as? [String: Any] {
            // logic goes here
            print("Received message from WebView:", body)
        }
    }

    // Native -> JavaScript
    func sendMessageToWebView(data: [String: Any]) {
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let script = "onMessageFromApp(\(jsonString));"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

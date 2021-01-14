//
//  WebViewAdapter
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation
import WebKit

public protocol WebViewProtocol: AnyObject {
    var configuration: WKWebViewConfiguration { get }
    func add(_ scriptMessageHandler: WKScriptMessageHandler, name: String)
    func load(_ request: URLRequest) -> WKNavigation?
    func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)?)
}

extension WebViewProtocol {
    public func add(_ scriptMessageHandler: WKScriptMessageHandler, name: String) {
        configuration.userContentController.add(scriptMessageHandler, name: name)
    }
}

extension WKWebView: WebViewProtocol { }

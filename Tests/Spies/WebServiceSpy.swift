//
//  WebServiceSpy
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
import WebKit
@testable import Dreams

class WebServiceSpy: NSObject, WebServiceType {
    
    var delegate: WebServiceDelegate?
    
    var events: [Request] = []
    var jsonObjects: [JSONObject] = []
    
    var load_urls: [URL] = []
    var load_methods: [String] = []
    var load_bodys: [JSONObject] = []
    
    func load(url: URL, method: String, body: JSONObject?) {
        load_urls.append(url)
        load_methods.append(method)
        guard let body = body else { return }
        load_bodys.append(body)
    }
    
    func handleResponseMessage(name: String, body: Any?) {
        fatalError("unimplemented")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        fatalError("unimplemented")
    }

    func prepareRequestMessage(event: Request, with jsonObject: JSONObject?) {
        events.append(event)
        guard let json = jsonObject else { return }
        jsonObjects.append(json)
    }
}

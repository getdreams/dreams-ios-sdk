//
//  DreamsWebService
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
import WebKit

typealias JSONObject = [String: Any]

class DreamsWebService: NSObject, DreamsWebServiceType {

    var delegate: DreamsWebServiceDelegate?

    func load(url: URL, method: String, body: JSONObject? = nil) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        if let httpBody = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        }
        delegate?.dreamsWebServiceDidPrepareRequest(service: self, urlRequest: urlRequest)
    }

    func prepareRequestMessage(event: DreamsEvent.Request, with jsonObject: JSONObject?) {
        guard let jsString = encode(event: event, with: jsonObject) else { return }
        delegate?.dreamsWebServiceDidPrepareMessage(service: self, jsString: jsString)
    }

    func handleResponseMessage(name: String, body: Any?) {
        let (e, jsonObject) = transform(name: name, body: body)
        guard let event = e else { return }
        delegate?.dreamsWebServiceDidReceiveMessage(service: self, event: event, jsonObject: jsonObject)
    }
}

private extension DreamsWebService {

    func encode(event: DreamsEvent.Request, with jsonObject: JSONObject?) -> String? {
        guard
            let jsonObject = jsonObject,
            let data = try? JSONSerialization.data(withJSONObject: jsonObject),
            let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        let message = "\(event.rawValue)('\(jsonString)')"
        return message
    }

    func transform(name: String, body: Any?) -> (DreamsEvent.Response?, JSONObject?) {
        let event = DreamsEvent.Response(rawValue: name)
        let jsonObject = body as? JSONObject
        return (event, jsonObject)
    }
}

extension DreamsWebService {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleResponseMessage(name: message.name, body: message.body)
    }
}

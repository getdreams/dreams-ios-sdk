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

protocol DreamsWebServiceDelegate {
    func dreamsWebServiceDidPrepareRequest(urlRequest: URLRequest)
    func dreamsWebServiceDidPrepareMessage(jsString: String)
    func dreamsWebServiceDidReceiveMessage(event: DreamsEvent.Response, jsonObject: JSONObject?)
}

protocol DreamsWebServiceType: WKScriptMessageHandler {

    var delegate: DreamsWebServiceDelegate? { get set }

    func load(url: URL, method: String, body: JSONObject?)
    func prepareRequestMessage(event: DreamsEvent.Request, with jsonObject: JSONObject?)
    func handleResponseMessage(name: String, body: Any?)
    func decode<T: Decodable>(object: JSONObject) -> T?
}

class DreamsWebService: NSObject, DreamsWebServiceType {

    var delegate: DreamsWebServiceDelegate?

    func load(url: URL, method: String, body: JSONObject? = nil) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        if let httpBody = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        }
        delegate?.dreamsWebServiceDidPrepareRequest(urlRequest: urlRequest)
    }

    func prepareRequestMessage(event: DreamsEvent.Request, with jsonObject: JSONObject?) {
        guard let jsString = encode(event: event, with: jsonObject) else { return }
        delegate?.dreamsWebServiceDidPrepareMessage(jsString: jsString)
    }

    func handleResponseMessage(name: String, body: Any?) {
        let (e, jsonObject) = transform(name: name, body: body)
        guard let event = e else { return }
        delegate?.dreamsWebServiceDidReceiveMessage(event: event, jsonObject: jsonObject)
    }

    func decode<T: Decodable>(object: JSONObject) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: object) else { return nil }
        return try? JSONDecoder().decode(T.self, from: jsonData)
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

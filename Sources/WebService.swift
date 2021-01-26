//
//  WebService
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

final class WebService: NSObject, WebServiceType {

    var delegate: WebServiceDelegate?
    
    private var completion: ((Result<Void, DreamsLaunchingError>) -> Void)?
    private var isRunning: Bool = false

    func load(url: URL, method: String, body: JSONObject? = nil, completion: ((Result<Void, DreamsLaunchingError>) -> Void)?) {
        guard !isRunning else {
            completion?(.failure(.alreadyLaunched))
            return
        }
        isRunning = true
        self.completion = completion
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method

        if let httpBody = body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: httpBody)
        }
        
        delegate?.webServiceDidPrepareRequest(service: self, urlRequest: urlRequest)
    }

    func prepareRequestMessage(event: Request, with jsonObject: JSONObject?) {
        guard let jsString = encode(event: event, with: jsonObject) else { return }
        delegate?.webServiceDidPrepareMessage(service: self, jsString: jsString)
    }

    func handleResponseMessage(name: String, body: Any?) {
        let (optionalEvent, jsonObject) = transformResponseMessage(name: name, body: body)
        guard let event = optionalEvent else { return }
        delegate?.webServiceDidReceiveMessage(service: self, event: event, jsonObject: jsonObject)
    }
}

private extension WebService {

    func encode(event: Request, with jsonObject: JSONObject?) -> String? {
        guard
            let jsonObject = jsonObject,
            let data = try? JSONSerialization.data(withJSONObject: jsonObject),
            let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        let message = "\(event.rawValue)('\(jsonString)')"
        return message
    }

    func transformResponseMessage(name: String, body: Any?) -> (ResponseEvent?, JSONObject?) {
        let event = ResponseEvent(rawValue: name)
        let jsonObject = body as? JSONObject
        return (event, jsonObject)
    }
}

extension WebService {

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleResponseMessage(name: message.name, body: message.body)
    }
}

// MARK: WKNavigationDelegate

extension WebService: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor
                 navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }
        switch response.statusCode {
        case 200...299:
            handleSuccess()
        case 422:
            handleError(.invalidCredentials)
        default:
            handleError(.httpErrorStatus(response.statusCode))
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(.requestFailure(error as NSError))
    }
    
    private func handleError(_ error: DreamsLaunchingError) {
        completion?(.failure(error))
        completion = nil
        isRunning = false
    }
    
    private func handleSuccess() {
        completion?(.success(()))
        completion = nil
        isRunning = false
    }
}

//
//  DreamsViewController
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import UIKit
import WebKit

public class DreamsViewController: UIViewController {

    public weak var delegate: DreamsViewControllerDelegate?

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    internal var webService: WebServiceType = WebService()
    internal var dreams = Dreams.shared

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func loadView() {
        view = webView
    }
}

extension DreamsViewController: DreamsViewControllerType {

    public func open(idToken: String, locale: Locale) {
        guard
            let clientId = dreams.clientId,
            let baseURL = dreams.baseURL else { return }

        let body = [
            "idToken": idToken,
            "locale": locale.identifier,
            "clientId": clientId
        ]

        webService.load(url: baseURL, method: "POST", body: body)
    }

    public func update(idToken: String, requestId: String) {
        let jsonObject: JSONObject = ["idToken": idToken, "requestId":  requestId]
        send(event: .updateIdToken, with: jsonObject)
    }

    public func update(locale: Locale) {
        let jsonObject: JSONObject = ["locale": locale.identifier]
        send(event: .updateLocale, with: jsonObject)
    }

    public func accountProvisionInitiated(requestId: String) {
        let jsonObject: JSONObject = ["requestId": requestId]
        send(event: .accountProvisionInitiated, with: jsonObject)
    }
}

private extension DreamsViewController {

    func setup() {
        webService.delegate = self

        Response.allCases.forEach {
            self.webView
                .configuration
                .userContentController
                .add(webService, name: $0.rawValue)
        }
    }

    func send(event: Request, with jsonObject: JSONObject?) {
        webService.prepareRequestMessage(event: event, with: jsonObject)
    }

    func handle(event: Response, with jsonObject: JSONObject?) {
        switch event {
        case .onIdTokenDidExpire:
            guard let requestId = jsonObject?["requestId"] as? String else { return }
            delegate?.dreamsViewControllerDelegateDidReceiveIdTokenExpired(vc: self, requestId: requestId)
        case .onTelemetryEvent:
            guard let name = jsonObject?["name"] as? String,
                  let payload = jsonObject?["payload"] as? JSONObject else { return }

            delegate?.dreamsViewControllerDelegateDidReceiveTelemetryEvent(vc: self, name: name, payload: payload)
        case .onAccountProvisionRequested:
            guard let requestId = jsonObject?["requestId"] as? String else { return }
            delegate?.dreamsViewControllerDelegateDidReceiveAccountProvisioningRequested(vc: self, requestId: requestId)
        case .onExitRequested:
            delegate?.dreamsViewControllerDelegateDidReceiveExitRequested(vc: self)
        }
    }
}


extension DreamsViewController: WebServiceDelegate {

    func webServiceDidPrepareRequest(service: WebServiceType, urlRequest: URLRequest) {
        webView.load(urlRequest)
    }

    func webServiceDidPrepareMessage(service: WebServiceType, jsString: String) {
        webView.evaluateJavaScript(jsString)
    }

    func webServiceDidReceiveMessage(service: WebServiceType, event: Response, jsonObject: JSONObject?) {
        handle(event: event, with: jsonObject)
    }
}

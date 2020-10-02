//
//  DreamsView
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

public protocol DreamsViewDelegate: class {
    func dreamsViewDelegateDidReceiveAccessTokenExpired(view: DreamsView)
    func dreamsViewDelegateDidReceiveOffboardingCompleted(view: DreamsView)
}

public class DreamsView: UIView {

    public weak var delegate: DreamsViewDelegate?

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    internal var dreamsWebService: DreamsWebServiceType = DreamsWebService()
    internal var dreams = Dreams.shared

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

public extension DreamsView {

    func open(accessToken: String, locale: Locale) {
        guard
            let clientId = dreams.clientId,
            let baseURL = dreams.baseURL else { return }

        let body = [
            "accessToken": accessToken,
            "locale": locale.identifier,
            "clientId": clientId
        ]
        dreamsWebService.load(url: baseURL, method: "POST", body: body)
    }

    func update(accessToken: String) {
        let jsonObject: JSONObject = ["accessToken": accessToken]
        send(event: .updateAccessToken, with: jsonObject)
    }

    func update(locale: Locale) {
        let jsonObject: JSONObject = ["locale": locale.identifier]
        send(event: .updateLocale, with: jsonObject)
    }
}

private extension DreamsView {

    func setup() {
        dreamsWebService.delegate = self
        addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leftAnchor
                .constraint(equalTo: leftAnchor),
            webView.topAnchor
                .constraint(equalTo: topAnchor),
            webView.rightAnchor
                .constraint(equalTo: rightAnchor),
            webView.bottomAnchor
                .constraint(equalTo: bottomAnchor)
        ])

        DreamsEvent.Response.allCases.forEach {
            self.webView
                .configuration
                .userContentController
                .add(dreamsWebService, name: $0.rawValue)
        }
    }

    func send(event: DreamsEvent.Request, with jsonObject: JSONObject?) {
        dreamsWebService.prepareRequestMessage(event: event, with: jsonObject)
    }

    func handle(event: DreamsEvent.Response, with jsonObject: JSONObject?) {
        switch event {
        case .onAccessTokenDidExpired:
            delegate?.dreamsViewDelegateDidReceiveAccessTokenExpired(view: self)
        case .onOnboardingDidComplete:
            delegate?.dreamsViewDelegateDidReceiveOffboardingCompleted(view: self)
        }
    }
}


extension DreamsView: DreamsWebServiceDelegate {

    func dreamsWebServiceDidPrepareRequest(urlRequest: URLRequest) {
        webView.load(urlRequest)
    }

    func dreamsWebServiceDidPrepareMessage(jsString: String) {
        webView.evaluateJavaScript(jsString)
    }

    func dreamsWebServiceDidReceiveMessage(event: DreamsEvent.Response, jsonObject: JSONObject?) {
        handle(event: event, with: jsonObject)
    }
}

//
//  DreamsNetworkInteraction
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

// MARK: DreamsNetworkInteraction

public final class DreamsNetworkInteraction: DreamsNetworkInteracting {

    private let webService: WebServiceType
    private let configuration: DreamsConfiguration
    private let localeFormatter: LocaleFormatting
    
    private weak var webView: WebViewProtocol!
    private weak var delegate: DreamsDelegate?
    private weak var navigation: ViewControllerPresenting?
    
    init(configuration: DreamsConfiguration, webService: WebServiceType, localeFormatter: LocaleFormatting) {
        self.configuration = configuration
        self.webService = webService
        self.localeFormatter = localeFormatter
    }
    
    // MARK: Public
    
    public func didLoad() {
        webService.delegate = self
    }
    
    public func use(webView: WebViewProtocol) {
        self.webView = webView
        setUpUserContentController()
        setUpNavigationDelegate()
    }
    
    public func use(delegate: DreamsDelegate) {
        self.delegate = delegate
    }

    public func use(navigation: ViewControllerPresenting) {
        self.navigation = navigation
    }
    
    public func launch(with credentials: DreamsCredentials, locale: Locale, completion: ((Result<Void, DreamsLaunchingError>) -> Void)?) {
        loadBaseURL(credentials: credentials, locale: locale, completion: completion)
    }
    
    public func update(locale: Locale) {
        let jsonObject: JSONObject = ["locale": locale.identifier]
        send(event: .updateLocale, with: jsonObject)
    }
    
    // MARK: Private

    private func handle(event: ResponseEvent, with jsonObject: JSONObject?) {
        switch event {
        case .onIdTokenDidExpire:
            guard let requestId = jsonObject?["requestId"] as? String else { return }
            delegate?.handleDreamsCredentialsExpired { [weak self] credentials in
                self?.update(idToken: credentials.idToken, requestId: requestId)
            }
        case .onTelemetryEvent:
            guard let name = jsonObject?["name"] as? String,
                  let payload = jsonObject?["payload"] as? JSONObject else { return }
            delegate?.handleDreamsTelemetryEvent(name: name, payload: payload)
        case .onAccountProvisionRequested:
            guard let requestId = jsonObject?["requestId"] as? String else { return }
            delegate?.handleDreamsAccountProvisionInitiated { [weak self] in
                self?.accountProvisionInitiated(requestId: requestId)
            }
        case .onExitRequested:
            delegate?.handleExitRequest()
        case .share:
            guard let text = jsonObject?["text"] as? String else { return }
            let title = jsonObject?["title"] as? String
            let url = jsonObject?["url"] as? String
            share(text: text, title: title, urlString: url)
        }
    }
    
    private func update(idToken: String, requestId: String) {
        let jsonObject: JSONObject = ["idToken": idToken, "requestId":  requestId]
        send(event: .updateIdToken, with: jsonObject)
    }

    private func accountProvisionInitiated(requestId: String) {
        let jsonObject: JSONObject = ["requestId": requestId]
        send(event: .accountProvisionInitiated, with: jsonObject)
    }
    
    private func setUpUserContentController() {
        ResponseEvent.allCases.forEach {
           webView.add(webService, name: $0.rawValue)
        }
    }
    
    private func setUpNavigationDelegate() {
        webView.navigationDelegate = webService
    }

    private func share(text: String, title: String?, urlString: String?) {
        var url: URL? = nil
        if let urlString = urlString {
            url = URL(string: urlString)
        }
        let items: [Any] = ([url, text] as [Any?]).compactMap({ $0 })
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        navigation?.present(viewController: activity)
    }
    
    private func loadBaseURL(credentials: DreamsCredentials, locale: Locale, completion: ((Result<Void, DreamsLaunchingError>) -> Void)?) {
    
        let body = [
            "token": credentials.idToken,
            "client_id": configuration.clientId,
            "locale": localeFormatter.format(locale: locale, format: .bcp47),
        ]
        
        let verifyTokenURL = configuration.baseURL.appendingPathComponent("/users/verify_token")

        webService.load(url: verifyTokenURL, method: "POST", body: body, completion: completion)
    }
}

// MARK: WebServiceDelegate

extension DreamsNetworkInteraction: WebServiceDelegate {
    func webServiceDidPrepareRequest(service: WebServiceType, urlRequest: URLRequest) {
        _ = webView.load(urlRequest)
    }

    func webServiceDidPrepareMessage(service: WebServiceType, jsString: String) {
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }

    func webServiceDidReceiveMessage(service: WebServiceType, event: ResponseEvent, jsonObject: JSONObject?) {
        handle(event: event, with: jsonObject)
    }
    
    func send(event: Request, with jsonObject: JSONObject?) {
        webService.prepareRequestMessage(event: event, with: jsonObject)
    }
}

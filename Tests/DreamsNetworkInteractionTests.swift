//
//  DreamsViewControllerDelegateTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
import WebKit
@testable import Dreams

final class DreamsNetworkInteractionTests: XCTestCase {
    
    private var service: WebServiceSpy!
    private var webView: WebViewSpy!
    private var delegate: DreamsDelegateSpy!
    
    private var subject: DreamsNetworkInteraction!
    
    override func setUpWithError() throws {
        let configuration = DreamsConfiguration(clientId: "clientId",
                                                baseURL: URL(string: "https://www.getdreams.com")!)
        service = WebServiceSpy()
        subject = DreamsNetworkInteraction(configuration: configuration,
                                                    webService: service)
        delegate = DreamsDelegateSpy()
        subject.use(delegate: delegate)
        
        webView = WebViewSpy(configuration: WKWebViewConfiguration())
        subject.use(webView: webView)
    }
    
    func test_didLoad_didSetDelegate() {
        subject.didLoad()
        
        XCTAssertNotNil(service.delegate)
    }
    
    func test_didLoad_addedHandlers() {
        subject.didLoad()
        
        XCTAssertEqual(webView.scriptMessageHandlers.count, 4)
    }
    
    func test_launch_calledCorrectRequest() {
        subject.launch(with: DreamsCredentials(idToken: "idToken"), locale: Locale(identifier: "sv_SE"))

        let expectedBody: [String: Any] = ["token": "idToken", "locale": "sv_SE", "client_id": "clientId"]
        let httpBody = service.load_bodys.first!
        XCTAssertEqual(service.load_urls.count, 1)
        XCTAssertEqual(service.load_bodys.count, 1)
        XCTAssertEqual(service.load_methods.count, 1)
        XCTAssertEqual(service.load_urls.first?.absoluteString, "https://www.getdreams.com/users/verify_token")
        XCTAssertEqual(service.load_methods.first, "POST")
        XCTAssertEqual(NSDictionary(dictionary: expectedBody), NSDictionary(dictionary: httpBody))
    }
    
    func test_webServiceDidPrepareRequest_requestedWebView() {
        let request = URLRequest(url: URL(string: "https://www.getdreams.com")!)
        subject.webServiceDidPrepareRequest(service: service, urlRequest: request)
        
        XCTAssertEqual(webView.requests.count, 1)
        XCTAssertEqual(webView.requests.first, request)
    }
    
    func test_webServiceDidPrepareMessage() {
        let jsString = "jsString"
        subject.webServiceDidPrepareMessage(service: service, jsString: jsString)
        
        XCTAssertEqual(webView.javaScriptStrings.count, 1)
        XCTAssertEqual(webView.javaScriptStrings.first, jsString)
    }

    func test_webServiceDidReceiveMessage_onAccountProvisionRequested_calledDelegate() {
        let event = ResponseEvent.onAccountProvisionRequested

        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject: ["requestId": "request_id"])
        
        XCTAssertEqual(delegate.handleDreamsAccountProvisionInitiatedCompletions.count, 1)
    }
    
    func test_webServiceDidReceiveMessage_onExitRequested_calledDelegate() {
        let event = ResponseEvent.onExitRequested
        
        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject: nil)
        
        XCTAssertEqual(delegate.handleExitRequestCount, 1)
    }
    
    func test_webServiceDidReceiveMessage_onIdTokenDidExpire_calledDelegate() {
        let event = ResponseEvent.onIdTokenDidExpire
        
        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject:  ["requestId": "request_id"])
        
        XCTAssertEqual(delegate.handleDreamsCredentialsExpiredCompletions.count, 1)
    }
    
    func test_webServiceDidReceiveMessage_onTelemetryEvent_calledDelegate() {
        let event = ResponseEvent.onTelemetryEvent
        let name = "name"
        
        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject:  ["name": name, "payload": ["a":"b"]])
        
        XCTAssertEqual(delegate.handleDreamsTelemetryEventNames.count, 1)
        XCTAssertEqual(delegate.handleDreamsTelemetryEventNames.first, name)
        XCTAssertEqual(delegate.handleDreamsTelemetryEventPayloads.count, 1)
    }
    
    func test_webServiceDidReceiveMessage_onAccountProvisionRequested_delegatePerformedACall() {
        let event = ResponseEvent.onAccountProvisionRequested
        let jsonObject =  ["requestId": "request_id"]

        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject: jsonObject)
        delegate.handleDreamsAccountProvisionInitiatedCompletions.first!()
        
        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(service.events.first, .accountProvisionInitiated)
        XCTAssertEqual(NSDictionary(dictionary: service.jsonObjects.first!), NSDictionary(dictionary: jsonObject))
    }

    
    func test_webServiceDidReceiveMessage_onIdTokenDidExpire_delegatePerformedACall() {
        let event = ResponseEvent.onIdTokenDidExpire
        let token = "bbb"
        let jsonObject =  ["requestId": "request_id"]
        
        subject.webServiceDidReceiveMessage(service: service, event: event, jsonObject:  jsonObject)
        delegate.handleDreamsCredentialsExpiredCompletions.first!(DreamsCredentials(idToken: token))
        
        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(service.events.first, .updateIdToken)
        
        let expectedJsonObject =  ["requestId": "request_id", "idToken": token]
        XCTAssertEqual(NSDictionary(dictionary: service.jsonObjects.first!), NSDictionary(dictionary: expectedJsonObject))
    }
    
    func test_send_serviceReceivedEvents() {
        let event = Request.accountProvisionInitiated
        
        subject.send(event: event, with: nil)
        
        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(service.events.first, event)
    }
    
    func test_uptadeLocale_passedToInteraction() {
        let event = Request.updateLocale
        
        subject.update(locale: Locale(identifier: "sv_SE"))
        
        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(service.events.first, event)
    }
}

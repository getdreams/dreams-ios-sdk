//
//  DreamsViewTests
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
@testable import Dreams

class DreamsViewTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        Dreams.setup(clientId: "clientId", baseURL: "https://www.getdreams.com")
    }

    override class func tearDown() {
        Dreams.shared.reset()
        super.tearDown()
    }

    func testDelegateCallbacks() {
        let service = WebService()
        let dreamsView = DreamsView()

        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

        service.handleResponseMessage(name: "onIdTokenDidExpire", body: nil)
        XCTAssertTrue(delegate.idTokenExpiredWasCalled)

        service.handleResponseMessage(name: "onTelemetryEvent", body: ["name": "test_event", "payload": ["test": "test"]])
        XCTAssertTrue(delegate.telemetryEventWasCalled)

        let lastTelemetryEvent = delegate.telemetryEvents.last
        let name = lastTelemetryEvent?["name"] as? String
        let payload = lastTelemetryEvent?["payload"] as? [String: Any]

        XCTAssertEqual(name, "test_event")
        XCTAssertEqual(NSDictionary(dictionary: payload!), NSDictionary(dictionary: ["test": "test"]))
    }

    func testInitialLoad() {
        let locale = Locale(identifier: "sv_SE")
        let delegate = WebServiceDelegateSpy()

        let dreamsView = DreamsView()
        dreamsView.webService.delegate = delegate
        dreamsView.open(idToken: "idToken", locale: locale)

        let event = delegate.events.last
        let request = event?["request"] as! URLRequest
        let httpBody = try! JSONSerialization.jsonObject(with: request.httpBody!) as! [String : Any]
        let expectedBody: [String: Any] = ["idToken": "idToken", "locale": "sv_SE", "clientId": "clientId"]

        XCTAssertEqual(delegate.events.count, 1)
        XCTAssertEqual(request.url?.absoluteString, "https://www.getdreams.com")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(NSDictionary(dictionary: expectedBody), NSDictionary(dictionary: httpBody))
    }

    func testUpdateIdTokenRequest() {
        let service = WebServiceSpy()
        let dreamsView = DreamsView()
        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView
        dreamsView.update(idToken: "anotherIdToken")

        let event = service.events.last
        let type = event?["event"] as! Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateIdToken)
        XCTAssertEqual(jsonObject["idToken"] as! String, "anotherIdToken")
    }

    func testUpdateIdTokenJSMessage() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebServiceSpy()

        let dreamsView = DreamsView()
        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        service.delegate = spyDelegate
        dreamsView.update(idToken: "anotherIdToken")

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedJSMessage = "updateIdToken('{\"idToken\":\"anotherIdToken\"}')"
        XCTAssertEqual(expectedJSMessage, message)
        XCTAssertEqual(service.events.count, 1)
    }

    func testUpdateLocaleRequest() {
        let locale = Locale(identifier: "en_US")
        let service = WebServiceSpy()
        let dreamsView = DreamsView()
        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView
        dreamsView.update(locale: locale)

        let event = service.events.last
        let type = event?["event"] as! Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateLocale)
        XCTAssertEqual(jsonObject["locale"] as! String, "en_US")
    }

    func testUpdateLocaleJSMessage() {
        let locale = Locale(identifier: "en_US")
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebServiceSpy()

        let dreamsView = DreamsView()
        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView
        
        service.delegate = spyDelegate
        dreamsView.update(locale: locale)

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedJSMessage = "updateLocale('{\"locale\":\"en_US\"}')"
        XCTAssertEqual(expectedJSMessage, message)
        XCTAssertEqual(service.events.count, 1)
    }
}

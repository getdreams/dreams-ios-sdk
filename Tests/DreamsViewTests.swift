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
        let service = DreamsWebService()
        let dreamsView = DreamsView()

        dreamsView.dreamsWebService = service
        dreamsView.dreamsWebService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

        service.handleResponseMessage(name: "onAccessTokenDidExpired", body: nil)
        XCTAssertTrue(delegate.accessTokenExpiredWasCalled)

        service.handleResponseMessage(name: "onOnboardingDidComplete", body: nil)
        XCTAssertTrue(delegate.offboardingWasCalled)
    }

    func testInitialLoad() {
        let locale = Locale(identifier: "sv_SE")
        let delegate = DreamsWebServiceDelegateSpy()

        let dreamsView = DreamsView()
        dreamsView.dreamsWebService.delegate = delegate
        dreamsView.open(accessToken: "accessToken", locale: locale)

        let event = delegate.events.last
        let request = event?["request"] as! URLRequest
        let httpBody = try! JSONSerialization.jsonObject(with: request.httpBody!) as! [String : Any]
        let expectedBody: [String: Any] = ["accessToken": "accessToken", "locale": "sv_SE", "clientId": "clientId"]

        XCTAssertEqual(delegate.events.count, 1)
        XCTAssertEqual(request.url?.absoluteString, "https://www.getdreams.com")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(NSDictionary(dictionary: expectedBody), NSDictionary(dictionary: httpBody))
    }

    func testUpdateAccessTokenRequest() {
        let service = DreamsWebServiceSpy()
        let dreamsView = DreamsView()
        dreamsView.dreamsWebService = service
        dreamsView.dreamsWebService.delegate = dreamsView
        dreamsView.update(accessToken: "anotherAccessToken")

        let event = service.events.last
        let type = event?["event"] as! DreamsEvent.Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateAccessToken)
        XCTAssertEqual(jsonObject["accessToken"] as! String, "anotherAccessToken")
    }

    func testUpdateAccessTokenJSMessage() {
        let spyDelegate = DreamsWebServiceDelegateSpy()
        let service = DreamsWebServiceSpy()

        let dreamsView = DreamsView()
        dreamsView.dreamsWebService = service
        dreamsView.dreamsWebService.delegate = dreamsView

        service.delegate = spyDelegate
        dreamsView.update(accessToken: "anotherAccessToken")

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedJSMessage = "updateAccessToken('{\"accessToken\":\"anotherAccessToken\"}')"
        XCTAssertEqual(expectedJSMessage, message)
        XCTAssertEqual(service.events.count, 1)
    }

    func testUpdateLocaleRequest() {
        let locale = Locale(identifier: "en_US")
        let service = DreamsWebServiceSpy()
        let dreamsView = DreamsView()
        dreamsView.dreamsWebService = service
        dreamsView.dreamsWebService.delegate = dreamsView
        dreamsView.update(locale: locale)

        let event = service.events.last
        let type = event?["event"] as! DreamsEvent.Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateLocale)
        XCTAssertEqual(jsonObject["locale"] as! String, "en_US")
    }

    func testUpdateLocaleJSMessage() {
        let locale = Locale(identifier: "en_US")
        let spyDelegate = DreamsWebServiceDelegateSpy()
        let service = DreamsWebServiceSpy()

        let dreamsView = DreamsView()
        dreamsView.dreamsWebService = service
        dreamsView.dreamsWebService.delegate = dreamsView
        
        service.delegate = spyDelegate
        dreamsView.update(locale: locale)

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedJSMessage = "updateLocale('{\"locale\":\"en_US\"}')"
        XCTAssertEqual(expectedJSMessage, message)
        XCTAssertEqual(service.events.count, 1)
    }
}

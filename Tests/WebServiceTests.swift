//
//  WebServiceTests
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

class WebServiceTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Dreams.setup(clientId: "clientId", baseURL: "https://www.getdreams.com")
    }

    override class func tearDown() {
        Dreams.shared.reset()
        super.tearDown()
    }

    func testLoadURL1() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let mockURL = URL(string: "https://getdreams.com")!
        service.load(url: mockURL, method: "POST", body: ["test": "test"])

        let event = spyDelegate.events.last
        let request = event?["request"] as! URLRequest

        XCTAssertEqual(request.url, mockURL)
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, try! JSONSerialization.data(withJSONObject: ["test": "test"]))
    }

    func testLoadURL2() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let mockURL = URL(string: "https://getdreams.com")!
        service.load(url: mockURL, method: "GET")

        let event = spyDelegate.events.last
        let request = event?["request"] as! URLRequest

        XCTAssertEqual(request.url, mockURL)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertNil(request.httpBody)
    }

    func testPrepareRequesteMessage() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate

        let jsonObject: JSONObject = ["idToken": "someIdToken"]
        service.prepareRequestMessage(event: .updateIdToken, with: jsonObject)

        let event = spyDelegate.events.last
        let message = event?["message"] as! String
        let expectedMessage = "updateIdToken('{\"idToken\":\"someIdToken\"}')"

        XCTAssertEqual(message, expectedMessage)
    }

    func testHandleResponseMessage() {
        let spyDelegate = WebServiceDelegateSpy()
        let service = WebService()
        service.delegate = spyDelegate
        service.handleResponseMessage(name: "onIdTokenDidExpire", body: nil)

        let event = spyDelegate.events.last
        let eventResponseType = event?["event"] as! Response
        
        XCTAssertEqual(eventResponseType, .onIdTokenDidExpire)
    }
}

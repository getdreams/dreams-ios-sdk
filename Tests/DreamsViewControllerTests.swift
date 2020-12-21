//
//  DreamsViewControllerTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
@testable import Dreams

class DreamsViewControllerTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        Dreams.setup(clientId: "clientId", baseURL: "https://www.getdreams.com")
    }

    override class func tearDown() {
        Dreams.shared.reset()
        super.tearDown()
    }

    func testInitialLoad() {
        let locale = Locale(identifier: "sv_SE")
        let delegate = WebServiceDelegateSpy()

        let vc = DreamsViewController()
        vc.webService.delegate = delegate
        vc.open(idToken: "idToken", locale: locale)

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
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc
        vc.update(idToken: "anotherIdToken", requestId: "anotherRequestId")

        let event = service.events.last
        let type = event?["event"] as! Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateIdToken)
        XCTAssertEqual(jsonObject["idToken"] as! String, "anotherIdToken")
        XCTAssertEqual(jsonObject["requestId"] as! String, "anotherRequestId")
    }

    func testUpdateLocaleRequest() {
        let locale = Locale(identifier: "en_US")
        let service = WebServiceSpy()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc
        vc.update(locale: locale)

        let event = service.events.last
        let type = event?["event"] as! Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .updateLocale)
        XCTAssertEqual(jsonObject["locale"] as! String, "en_US")
    }

    func testAccountProvisionInitiatedRequest() {
        let service = WebServiceSpy()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc
        vc.accountProvisionInitiated(requestId: "requestId")

        let event = service.events.last
        let type = event?["event"] as! Request
        let jsonObject = event?["jsonObject"] as! JSONObject

        XCTAssertEqual(service.events.count, 1)
        XCTAssertEqual(type, .accountProvisionInitiated)
        XCTAssertEqual(jsonObject["requestId"] as! String, "requestId")
    }
}

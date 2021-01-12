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
@testable import Dreams

class DreamsViewControllerDelegateTests: XCTestCase {

    func testDelegateDidReceiveIdTokenExpired() {
        let service = WebService()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc

        let delegate = DreamsViewControllerDelegateSpy()
        vc.delegate = delegate

        service.handleResponseMessage(name: "onIdTokenDidExpire", body: ["requestId": "request_id"])
        XCTAssertTrue(delegate.idTokenExpiredWasCalled)

        let requestId = delegate.idTokenRequestIds.last
        XCTAssertEqual(requestId, "request_id")
    }

    func testDelegateDidReceiveTelemetryEvent() {
        let service = WebService()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc

        let delegate = DreamsViewControllerDelegateSpy()
        vc.delegate = delegate

        service.handleResponseMessage(name: "onTelemetryEvent", body: ["name": "test_event", "payload": ["test": "test"]])
        XCTAssertTrue(delegate.telemetryEventWasCalled)

        let lastTelemetryEvent = delegate.telemetryEvents.last
        let name = lastTelemetryEvent?["name"] as? String
        let payload = lastTelemetryEvent?["payload"] as? [String: Any]

        XCTAssertEqual(name, "test_event")
        XCTAssertEqual(NSDictionary(dictionary: payload!), NSDictionary(dictionary: ["test": "test"]))
    }

    func testDelegateDidReceiveAccountProvisioningRequested() {
        let service = WebService()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc

        let delegate = DreamsViewControllerDelegateSpy()
        vc.delegate = delegate

        service.handleResponseMessage(name: "onAccountProvisionRequested", body: ["requestId": "request_id"])
        XCTAssertTrue(delegate.accountProvisioningRequestedWasCalled)

        let requestId = delegate.accountProvisioningRequestIds.last
        XCTAssertEqual(requestId, "request_id")
    }

    func testDelegateDidReceiveExitRequested() {
        let service = WebService()
        let vc = DreamsViewController()

        vc.webService = service
        vc.webService.delegate = vc

        let delegate = DreamsViewControllerDelegateSpy()
        vc.delegate = delegate

        service.handleResponseMessage(name: "onExitRequested", body:nil)
        XCTAssertTrue(delegate.exitRequestedWasCalled)
    }
}
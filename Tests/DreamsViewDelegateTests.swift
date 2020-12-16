//
//  DreamsViewDelegateTests
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

class DreamsViewDelegateTests: XCTestCase {

    func testDelegateDidReceiveIdTokenExpired() {
        let service = WebService()
        let dreamsView = DreamsView()

        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

        service.handleResponseMessage(name: "onIdTokenDidExpire", body: nil)
        XCTAssertTrue(delegate.idTokenExpiredWasCalled)
    }

    func testDelegateDidReceiveTelemetryEvent() {
        let service = WebService()
        let dreamsView = DreamsView()

        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

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
        let dreamsView = DreamsView()

        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

        service.handleResponseMessage(name: "onAccountProvisionRequested", body: ["requestId": "request_id"])
        XCTAssertTrue(delegate.accountProvisioningRequestedWasCalled)

        let requestId = delegate.accountProvisioningRequestIds.last
        XCTAssertEqual(requestId, "request_id")
    }

    func testDelegateDidReceiveExitRequested() {
        let service = WebService()
        let dreamsView = DreamsView()

        dreamsView.webService = service
        dreamsView.webService.delegate = dreamsView

        let delegate = DreamsViewDelegateSpy()
        dreamsView.delegate = delegate

        service.handleResponseMessage(name: "onExitRequested", body:nil)
        XCTAssertTrue(delegate.exitRequestedWasCalled)
    }
}

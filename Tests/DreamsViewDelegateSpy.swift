//
//  DreamsViewDelegateSpy
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
@testable import Dreams

class DreamsViewDelegateSpy: DreamsViewDelegate {

    var idTokenExpiredWasCalled: Bool = false
    var telemetryEventWasCalled: Bool = false
    var accountProvisioningRequestedWasCalled: Bool = false
    var exitRequestedWasCalled: Bool = false

    var telemetryEvents: [[String: Any]] = []
    var accountProvisioningRequestIds: [String] = []

    func dreamsViewDelegateDidReceiveIdTokenExpired(view: DreamsView) {
        idTokenExpiredWasCalled = true
    }

    func dreamsViewDelegateDidReceiveTelemetryEvent(view: DreamsView, name: String, payload: [String: Any]) {
        telemetryEventWasCalled = true
        let telemetryEvent: [String: Any] = ["name": name, "payload": payload]
        telemetryEvents.append(telemetryEvent)
    }

    func dreamsViewDelegateDidReceiveAccountProvisioningRequested(view: DreamsView, requestId: String) {
        accountProvisioningRequestedWasCalled = true
        accountProvisioningRequestIds.append(requestId)
    }

    func dreamsViewDelegateDidReceiveExitRequested(view: DreamsView) {
        exitRequestedWasCalled = true
    }
}

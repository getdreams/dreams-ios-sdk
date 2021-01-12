//
//  DreamsViewControllerDelegateSpy
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
@testable import Dreams

class DreamsViewControllerDelegateSpy: DreamsViewControllerDelegate {

    var idTokenExpiredWasCalled: Bool = false
    var telemetryEventWasCalled: Bool = false
    var accountProvisioningRequestedWasCalled: Bool = false
    var exitRequestedWasCalled: Bool = false

    var idTokenRequestIds: [String] = []
    var telemetryEvents: [[String: Any]] = []
    var accountProvisioningRequestIds: [String] = []

    func dreamsViewControllerDelegateDidReceiveIdTokenExpired(vc: DreamsViewController, requestId: String) {
        idTokenExpiredWasCalled = true
        idTokenRequestIds.append(requestId)
    }

    func dreamsViewControllerDelegateDidReceiveTelemetryEvent(vc: DreamsViewController, name: String, payload: [String: Any]) {
        telemetryEventWasCalled = true
        let telemetryEvent: [String: Any] = ["name": name, "payload": payload]
        telemetryEvents.append(telemetryEvent)
    }

    func dreamsViewControllerDelegateDidReceiveAccountProvisioningRequested(vc: DreamsViewController, requestId: String) {
        accountProvisioningRequestedWasCalled = true
        accountProvisioningRequestIds.append(requestId)
    }

    func dreamsViewControllerDelegateDidReceiveExitRequested(vc: DreamsViewController) {
        exitRequestedWasCalled = true
    }
}

//
//  DreamsViewControllerDelegate
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation

/**
 The delegate for the `DreamsViewController`.
 */

public protocol DreamsViewControllerDelegate: class {

    /**
     Delegate callback when the idToken has expired.
     - parameter vc: The dreams viewcontroller invoking the delegate method.
     - parameter requestId: The requestId that should be sent back when passing a new valid idToken.
     */
    func dreamsViewControllerDelegateDidReceiveIdTokenExpired(vc: DreamsViewController, requestId: String)

    /**
     Delegate callback when a telemetry event is received.
     - parameter vc: The dreams viewcontroller invoking the delegate method.
     - parameter name: The name of the received telemetry event.
     - parameter payload: The payload containing telemetry event data.
     */
    func dreamsViewControllerDelegateDidReceiveTelemetryEvent(vc: DreamsViewController, name: String, payload: [String: Any])

    /**
     Delegate callback when an account should be provisioned.
     - parameter vc: The dreams viewcontroller invokting the delegate method.
     - parameter requestId: The requestId that should be sent back when the account has been provisioned.
     */
    func dreamsViewControllerDelegateDidReceiveAccountProvisioningRequested(vc: DreamsViewController, requestId: String)

    /**
    Delegate callback when a exit request is received.
     - parameter vc: The dreams viewcontroller invoking the delegate method.

     # Notes: #
     Use this delegate callback to close or dismiss the dreams viewcontroller.
     */
    func dreamsViewControllerDelegateDidReceiveExitRequested(vc: DreamsViewController)
}

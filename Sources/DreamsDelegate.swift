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
 The delegate for the `Dreams` SDK.
 */

public protocol DreamsDelegate: AnyObject {

    /**
     Called when the credentials has expired.
     */
    func handleDreamsCredentialsExpired(completion: @escaping (_ credentials: DreamsCredentials) -> Void)

    /**
     Called when a telemetry event is received.
     - parameter name: The name of the received telemetry event.
     - parameter payload: The payload containing telemetry event data.
     */
    func handleDreamsTelemetryEvent(name: String, payload: [String: Any])

    /**
     Called when an account should be provisioned.
     */
    func handleDreamsAccountProvisionInitiated(completion: @escaping () -> Void)

    /**
    Called when an exit request is received.

     # Notes: #
     Use this delegate callback to close or dismiss the dreams viewcontroller.
     */
    func handleExitRequest()
    
    /**
        Called when a transfer requires a consent.
     */

    func handleDreamsTransferConsentRequested(requestId: String, consentId: String, completion: @escaping (Result<TransferConsentSuccess, TransferConsentError>) -> Void)
}

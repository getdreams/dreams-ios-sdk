//
//  DreamsViewType
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation

public protocol DreamsViewType {

    /**
     Open the dreams view.
     - parameter idToken: The idToken.
     - parameter locale: The users locale.
     */
    func open(idToken: String, locale: Locale)

    /**
     Update the idToken.
     - parameter idToken: The new idToken.
     - parameter requestId: The received requestId.

     # Notes: #
     The requestId is received from the dreamsViewDelegateDidReceiveIdTokenExpired(:view:requestId:) delegate method.
     */
    func update(idToken: String, requestId: String)

    /**
     Update the locale.
     - parameter locale: The new locale.
     */
    func update(locale: Locale)

    /**
     Inform that the account was provisioned.
     - parameter requestId: The received requestId.

     # Notes: #
     The requestId is received from the dreamsViewDelegateDidReceiveAccountProvisioningRequested(:view:requestId:) delegate method.
    */
    func accountProvisionInitiated(requestId: String)
}

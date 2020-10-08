//
//  DreamsViewDelegate
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
 The delegate for the `DreamsView`.
 */

public protocol DreamsViewDelegate: class {

    /**
     Delegate callback when the access token has expired.
     - parameter view: The dreams view invoking the delegate method.
     */
    func dreamsViewDelegateDidReceiveAccessTokenExpired(view: DreamsView)

    /**
     Delegate callback when an offboarding has been completed.
     - parameter view: The dreams view invoking the delegate method.
     */
    func dreamsViewDelegateDidReceiveOffboardingCompleted(view: DreamsView)
}

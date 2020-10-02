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

    var accessTokenExpiredWasCalled: Bool = false
    var offboardingWasCalled: Bool = false

    func dreamsViewDelegateDidReceiveAccessTokenExpired(view: DreamsView) {
        accessTokenExpiredWasCalled = true
    }

    func dreamsViewDelegateDidReceiveOffboardingCompleted(view: DreamsView) {
        offboardingWasCalled = true
    }
}

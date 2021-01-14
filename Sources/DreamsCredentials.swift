//
//  DreamsCredentials
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

public struct DreamsCredentials {
    /**
    Token of the signed in user
     */
    let idToken: String
    
    /**
     Create DreamsCredentials
     - parameter idToken: Token of the signed in user
     */
    public init(idToken: String) {
        self.idToken = idToken
    }
}

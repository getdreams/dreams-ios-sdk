//
//  DreamsLaunchingError
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

public enum DreamsLaunchingError: Error, Equatable {
    case alreadyLaunched
    case invalidCredentials
    case httpErrorStatus(Int)
    case requestFailure(NSError)
}

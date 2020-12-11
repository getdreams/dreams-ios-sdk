//
//  DreamsEvent
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation

enum DreamsEvent {

    /**
     The javascript request events supported.
     */
    enum Request: String {
        case updateIdToken
        case updateLocale
    }

    /**
     The javascript response events supported.
     */
    enum Response: String, CaseIterable {
        case onIdTokenDidExpire
        case onTelemetryEvent
        case onOnboardingDidComplete
    }
}

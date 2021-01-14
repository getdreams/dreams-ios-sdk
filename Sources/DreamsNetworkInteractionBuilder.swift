//
//  DreamsNetworkInteractionBuilder
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.
//

import Foundation

public enum DreamsNetworkInteractionBuilder {
    static func build(configuration: DreamsConfiguration) -> DreamsNetworkInteracting & WebServiceDelegate {
        let webService = WebService()
        return DreamsNetworkInteraction(configuration: configuration, webService: webService)
    }
}

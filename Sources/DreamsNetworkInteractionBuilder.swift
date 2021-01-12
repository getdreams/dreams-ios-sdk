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
    static func build() -> DreamsNetworkInteracting & WebServiceDelegate {
        
        guard let configuration = Dreams.shared.configuration else {
            fatalError("Dreams.shared.configuration must be set before DreamsNetworkInteractionBuilder.build() is called!")
        }
        
        let webService = WebService()
        return DreamsNetworkInteraction(configuration: configuration, webService: webService)
    }
}

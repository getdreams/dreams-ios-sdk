//
//  TransferConsent
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2021 Dreams AB.s
//

import Foundation

public struct TransferConsentError: Error {
    public init(requestId: String, consentId: String) {
        self.requestId = requestId
        self.consentId = consentId
    }
    
    let requestId: String
    let consentId: String
    
    
}

public struct TransferConsentSuccess {
    public init(requestId: String, consentId: String, consentRef: String) {
        self.requestId = requestId
        self.consentId = consentId
        self.consentRef = consentRef
    }
    
    let requestId: String
    let consentId: String
    let consentRef: String
    
}

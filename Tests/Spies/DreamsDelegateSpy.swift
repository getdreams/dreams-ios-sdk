//
//  DreamsViewControllerDelegateSpy
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
@testable import Dreams

final class DreamsDelegateSpy: DreamsDelegate {
    
    var handleDreamsCredentialsExpiredCompletions: [(DreamsCredentials) -> Void] = []
    var handleDreamsTelemetryEventNames: [String] = []
    var handleDreamsTelemetryEventPayloads: [[String : Any]] = []
    var handleDreamsAccountProvisionInitiatedCompletions: [() -> Void] = []
    var handleDreamsTransferConsentRequestedCompletions: [(String, String, String) -> Void] = []
    var handleExitRequestCount = 0
    
    func handleDreamsCredentialsExpired(completion: @escaping (DreamsCredentials) -> Void) {
        handleDreamsCredentialsExpiredCompletions.append(completion)
    }
    
    func handleDreamsTelemetryEvent(name: String, payload: [String : Any]) {
        handleDreamsTelemetryEventNames.append(name)
        handleDreamsTelemetryEventPayloads.append(payload)
    }
    
    func handleDreamsAccountProvisionInitiated(completion: @escaping () -> Void) {
        handleDreamsAccountProvisionInitiatedCompletions.append(completion)
    }
    
    func handleDreamsTransferConsentRequested(requestId: String, consentId: String, completion: @escaping (Result<TransferConsentSuccess, TransferConsentError>) -> Void) {
        if (consentId == "invalid fail me") {
            completion(.failure(TransferConsentError(requestId: requestId, consentId: consentId)))
        } else {
            completion(.success(TransferConsentSuccess(requestId: requestId, consentId: consentId, consentRef: "test consent ref")))
        }
    }
    
    func handleExitRequest() {
        handleExitRequestCount += 1
    }
}

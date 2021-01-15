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
    
    func handleExitRequest() {
        handleExitRequestCount += 1
    }
}

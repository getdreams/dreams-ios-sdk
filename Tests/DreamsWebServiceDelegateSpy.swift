//
//  DreamsWebServiceDelegateSpy
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

class DreamsWebServiceDelegateSpy: DreamsWebServiceDelegate {

    var events: [[String: Any?]] = []

    func dreamsWebServiceDidPrepareRequest(urlRequest: URLRequest) {
        events.append(["request": urlRequest])
    }

    func dreamsWebServiceDidPrepareMessage(jsString: String) {
        events.append(["message": jsString])
    }

    func dreamsWebServiceDidReceiveMessage(event: DreamsEvent.Response, jsonObject: JSONObject?) {
        events.append(["event": event, "jsonObject": jsonObject])
    }
}

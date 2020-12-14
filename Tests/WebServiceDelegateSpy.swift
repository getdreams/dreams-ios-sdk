//
//  WebServiceDelegateSpy
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

class WebServiceDelegateSpy: WebServiceDelegate {

    var events: [[String: Any?]] = []

    func webServiceDidPrepareRequest(service: WebServiceType, urlRequest: URLRequest) {
        events.append(["request": urlRequest])
    }

    func webServiceDidPrepareMessage(service: WebServiceType, jsString: String) {
        events.append(["message": jsString])
    }

    func webServiceDidReceiveMessage(service: WebServiceType, event: Response, jsonObject: JSONObject?) {
        events.append(["event": event, "jsonObject": jsonObject])
    }
}

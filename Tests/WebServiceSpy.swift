//
//  WebServiceSpy
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

class WebServiceSpy: WebService {

    var events: [[String: Any?]] = []

    override func prepareRequestMessage(event: Request, with jsonObject: JSONObject?) {
        events.append(["event": event, "jsonObject": jsonObject])
        super.prepareRequestMessage(event: event, with: jsonObject)
    }
}

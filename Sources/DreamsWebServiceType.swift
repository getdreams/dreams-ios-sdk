//
//  DreamsWebServiceType
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
import WebKit

protocol DreamsWebServiceType: WKScriptMessageHandler {

    /**
     The object that acts as the delegate of the dreams web service.
     */
    var delegate: DreamsWebServiceDelegate? { get set }

    /**
     Load URL with HTTP method and an optional body.
     - parameter url: The URL to load.
     - parameter method: The HTTP method to perform.
     - parameter body: (optional) The json body to send.

     # Notes: #
     If the delegate property is set, calling this function will trigger the `dreamsWebServiceDidPrepareRequest:service:urlRequest: delegate callback`
     */
    func load(url: URL, method: String, body: JSONObject?)

    /**
     Prepare request message to be sent to the web view.
     - parameter event: The request event.
     - parameter body: (optional) The json body to send.

     # Notes: #
     If the delegate property is set, calling this function will trigger the `dreamsWebServiceDidPrepareMessage(:service:jsString:) delegate callback`.
     */
    func prepareRequestMessage(event: DreamsEvent.Request, with jsonObject: JSONObject?)

    /**
     Handle the response message from the web view.
     - parameter name: The message name (Usually the name property from the WKScriptMessage).
     - parameter body: (optional) The message body (Usually the body property from the WKScriptMessage).

     # Notes: #
     If the delegate property is set, calling this function will trigger the `dreamsWebServiceDidReceiveMessage(:service:event:jsonObject:) delegate callback`.
     */
    func handleResponseMessage(name: String, body: Any?)
}

//
//  WebServiceType
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

protocol WebServiceType: WKScriptMessageHandler {

    /**
     The object that acts as the delegate of the web service.
     */
    var delegate: WebServiceDelegate? { get set }

    /**
     Load URL with HTTP method and an optional body.
     - parameter url: The URL to load.
     - parameter method: The HTTP method to perform.
     - parameter body: (optional) The json body to send.

     # Notes: #
     If the delegate property is set, calling this function will trigger the `webServiceDidPrepareRequest:service:urlRequest: delegate callback`
     */
    func load(url: URL, method: String, body: JSONObject?)

    /**
     Prepare request message to be sent to the web view.
     - parameter event: The request event.
     - parameter body: (optional) The json body to send.

     # Notes: #
     If the delegate property is set, calling this function will trigger the `webServiceDidPrepareMessage(:service:jsString:) delegate callback`.
     */
    func prepareRequestMessage(event: Request, with jsonObject: JSONObject?)

    /**
     Handle the response message from the web view.
     - parameter name: The message name (Usually the name property from the WKScriptMessage).
     - parameter body: (optional) The message body (Usually the body property from the WKScriptMessage).

     # Notes: #
     If the delegate property is set, calling this function will trigger the `webServiceDidReceiveMessage(:service:event:jsonObject:) delegate callback`.
     */
    func handleResponseMessage(name: String, body: Any?)
}

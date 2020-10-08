//
//  Dreams
//  Dreams
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import Foundation
import UIKit

public class Dreams {

    /**
     The client id from the setup function.
     */
    public internal (set) var clientId: String?

    /**
     The base url from the setup function.
     */
    public internal (set) var baseURL: URL?

    /**
     Boolean indicating if the shared instance is initialized or not.
     */
    public internal (set) var initialized: Bool = false

    /**
     The shared singleton instance.
     */
    public static var shared = Dreams()

    /**
     Required setup when using the Dreams iOS SDK
     - parameter clientId: The client id.
     - parameter baseURL: The base url.

     # Notes: #
     Call this function in your AppDelegates `application(_:didFinishLaunchingWithOptions:)` .
     */
    public static func setup(clientId: String, baseURL: String) {
        guard let baseURL = URL(string: baseURL) else { return }
        guard !clientId.isEmpty else { return }

        Dreams.shared.clientId = clientId
        Dreams.shared.baseURL = baseURL
        Dreams.shared.initialized = true
    }

    internal init() {}
}

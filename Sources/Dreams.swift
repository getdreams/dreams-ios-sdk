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

    public internal (set) var clientId: String?
    public internal (set) var baseURL: URL?
    public internal (set) var initialized: Bool = false

    public static var shared = Dreams()

    public static func setup(clientId: String, baseURL: String) {
        guard let baseURL = URL(string: baseURL) else { return }
        guard !clientId.isEmpty else { return }

        Dreams.shared.clientId = clientId
        Dreams.shared.baseURL = baseURL
        Dreams.shared.initialized = true
    }
}

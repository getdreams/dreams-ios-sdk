//
//  DreamsTests
//  DreamsTests
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
//  Copyright © 2020 Dreams AB.
//

import XCTest
@testable import Dreams

class DreamsTests: XCTestCase {
    func testConfiguration() {
        XCTAssertNil(Dreams.shared.configuration)
        Dreams.configure(clientId: "clientId", baseURL: URL(string: "https://getdreams.com")!)
        XCTAssertEqual(Dreams.shared.configuration!.baseURL, URL(string: "https://getdreams.com")!)
        XCTAssertEqual(Dreams.shared.configuration!.clientId, "clientId")
    }
}
